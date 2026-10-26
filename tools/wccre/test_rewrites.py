#!/usr/bin/env python3
"""Regression checks for natural low-part and register-tie rewrites.

  python3 tools/wccre/test_rewrites.py

The optional native-compiler check compares behavior across signed values, masks and side effects.
Watcom/DOSBox byte matching is checked separately with targetsearch.py.
"""
import ctypes
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import rewrites


def function(body, params='int x', declarations=''):
    return 'int F(%s)\n{\n%s%s\n}\n' % (params, declarations, body)


def edits(text, family):
    return rewrites.neighbours(text, 'F', only=[family])


class RewriteTests(unittest.TestCase):
    def test_byte_and_word_mask_and_declaration_positions(self):
        for mask, widths in [('0x30', ('u8', 'u16')), ('0x300', ('u16',))]:
            src = 'int read_pad(void);\n' + function(
                '    if (((read_pad() >> x) & %s) == 0) return used;\n    return 0;' % mask,
                declarations='    int used;\n    used = x;\n')
            nb = edits(src, 'narrow')
            for width in widths:
                self.assertTrue(any(':%s:first' % width in d for d, _ in nb))
                self.assertTrue(any(':%s:last' % width in d for d, _ in nb))
            if mask == '0x300': self.assertFalse(any(':u8:' in d for d, _ in nb))

    def test_no_copy_and_no_signature_change(self):
        src = function('    if ((x & 0x30) == 0) return 1;\n    return 0;')
        self.assertEqual(edits(src, 'narrow'), [])
        src = function('    out = x;\n    return out;', declarations='    short out;\n')
        self.assertEqual(edits(src, 'narrow'), [])

    def test_conditional_loop_and_effect_order_are_preserved(self):
        statements = [
            '    while ((read_pad() & 0x30) != 0) x++;\n    return x;',
            '    for (; (read_pad() & 0x30) != 0; ) x++;\n    return x;',
            '    if (x && ((read_pad() & 0x30) == 0)) return 1;\n    return 0;',
            '    if (x ? ((read_pad() & 0x30) == 0) : 0) return 1;\n    return 0;',
            '    if (sizeof(read_pad() & 0x30)) return 1;\n    return 0;',
            '    if ((read_pad() & 0x30) == other()) return 1;\n    return 0;',
            '    if (x)\n        if ((read_pad() & 0x30) == 0) return 1;\n    return 0;',
            '    p[x++] = (read_pad() & 0x30);\n    return x;',
        ]
        for body in statements:
            src = 'int read_pad(void);\nint other(void);\n' + function(body, 'int x, int *p')
            with self.subTest(body=body):
                self.assertEqual(edits(src, 'narrow'), [])

    def test_existing_local_requires_every_read_to_be_low(self):
        base = 'int read_pad(void);\n' + function(
            '    value = read_pad() + x;\n%s\n    return x;',
            declarations='    int value;\n')
        masked = base % '    x = value & 0x30;'
        self.assertTrue(any(d == 'narrow:local:value:u8' for d, _ in edits(masked, 'narrow')))
        for read in ['    x = value;', '    if (x) x = value;', '    x = value >> 8;']:
            with self.subTest(read=read):
                self.assertFalse(any(d.startswith('narrow:local:value:') for d, _ in edits(base % read, 'narrow')))
        floating = base.replace('int read_pad(void);', 'double read_pad(void);') % '    x = value & 0x30;'
        self.assertFalse(any(d.startswith('narrow:local:value:') for d, _ in edits(floating, 'narrow')))

    def test_existing_local_masked_return_and_short_to_byte(self):
        src = 'int read_pad(void);\n' + function(
            '    value = read_pad() + x;\n    return value & 0xFF;',
            declarations='    short value;\n')
        self.assertTrue(any(d == 'narrow:local:value:u8' for d, _ in edits(src, 'narrow')))

    def test_new_name_does_not_clash_and_members_survive_cleanup(self):
        src = function('    lo8 = x;\n    s.bank = x;\n    s.shape = x + 1;\n'
                       '    if (((x + 3) & 0x30) == 0) return lo8;\n    return s.shape;',
                       declarations='    int lo8;\n    struct {\n        int bank;\n        int shape;\n    } s;\n')
        nb = edits(src, 'narrow')
        self.assertTrue(nb)
        for _, text in nb:
            self.assertIn('int bank;', text)
            self.assertIn('int shape;', text)
            if 'unsigned char' in text: self.assertIn('unsigned char lo8_;', text)

    def alias_source(self, stores, before=''):
        return function('    gx = x + 1;\n    gy = x + 2;\n' + before + stores + '\n    return a + b;',
                        declarations='    int gx;\n    int gy;\n    short a;\n    short b;\n')

    def test_alias16_independent_and_dependent_stores(self):
        src = self.alias_source('    a = gx + 3;\n    b = gy + 4;')
        nb = edits(src, 'alias16')
        self.assertTrue(any(d.startswith('alias16:statement:') and
                            text.index('b = gy + 4;') < text.index('a = gx + 3;') for d, text in nb))
        for stores in ['    a = gx + 3;\n    b = gy + a;',
                       '    if (x)\n        a = gx + 3;\n    b = gy + 4;']:
            self.assertFalse(any(d.startswith('alias16:statement:') for d, _ in edits(self.alias_source(stores), 'alias16')))

    def test_alias16_honors_earlier_casts(self):
        src = self.alias_source('    a = gx + 3;\n    b = gy + 4;', '    if ((short)gx) x++;\n')
        self.assertFalse(any(d.startswith('alias16:statement:') for d, _ in edits(src, 'alias16')))

    def test_alias16_word_operand_order_and_disjoint_fields(self):
        src = function('    gx = x;\n    gy = x + 1;\n'
                       '    HIWORD(p->Xpos) = gx + gy;\n    return x;', 'int x, Player *p',
                       '    int gx;\n    int gy;\n')
        self.assertTrue(any('HIWORD(p->Xpos) = gy + gx;' in t for _, t in edits(src, 'alias16')))
        src = src.replace('HIWORD(p->Xpos) = gx + gy;',
                          'HIWORD(p->Xpos) = gx + 1;\n    HIWORD(p->Ypos) = gy + 2;')
        self.assertTrue(any(d.startswith('alias16:statement:') for d, _ in edits(src, 'alias16')))
        for bad in ['HIWORD(p->Ypos) = gy + p->Xpos;',
                    'HIWORD(p->Xpos) = gy + 2;',
                    'HIWORD(p->Ypos) = gy + other();']:
            broken = src.replace('HIWORD(p->Ypos) = gy + 2;', bad)
            self.assertFalse(any(d.startswith('alias16:statement:') for d, _ in edits(broken, 'alias16')))

    def test_declorder_ranks_reversed_names_walk_without_moving_parameters(self):
        src = function('    a = x;\n    b = x + 1;\n    c = x + 2;\n    return a + b + c;',
                       declarations='    int a;\n    int b;\n    int c;\n')
        model = [(['c', 'b', 'a'], {'a': 2, 'b': 2, 'c': 2}, {'a', 'b', 'c'}, [('a', 'b')])]
        with patch.object(rewrites, 'declaration_models', return_value=model) as compile_model:
            nb = rewrites.neighbours(src, 'F', only=['declorder'], target=[('a', 'b', 0)])
        self.assertEqual(compile_model.call_count, 1)
        self.assertTrue(nb[0][0].endswith(':target=0'))
        self.assertEqual([int(d.rsplit('=', 1)[1]) for d, _ in nb],
                         sorted(int(d.rsplit('=', 1)[1]) for d, _ in nb))
        for _, text in nb: self.assertTrue(text.startswith('int F(int x)\n'))

    @unittest.skipUnless(shutil.which('gcc'), 'native gcc is optional')
    def test_narrow_preserves_results_and_call_count(self):
        src = ('int feed;\nint calls;\nint read_pad(void) { calls++; return feed; }\n' +
               function('    feed = x;\n    calls = 0;\n'
                        '    if (((read_pad() >> shift) & 0x30) == 0) x = 123;\n'
                        '    return (calls << 16) | (x & 0xFFFF);', 'int x, int shift'))
        variants = [('baseline', src)] + edits(src, 'narrow')
        self.assertGreater(len(variants), 1)
        with tempfile.TemporaryDirectory(prefix='rw_semantics_') as tmp:
            functions = []
            for i, (desc, text) in enumerate(variants):
                lib = os.path.join(tmp, 'variant%d.so' % i)
                subprocess.run(['gcc', '-shared', '-fPIC', '-fwrapv', '-x', 'c', '-', '-o', lib],
                               input=text, text=True, check=True, capture_output=True)
                f = ctypes.CDLL(lib).F
                f.argtypes = [ctypes.c_int, ctypes.c_int]; f.restype = ctypes.c_int
                functions.append((desc, f))
            for x in (-65537, -1024, -1, 0, 1, 47, 48, 255, 256, 65535, 0x12345678):
                for shift in (0, 1, 7, 15):
                    want = functions[0][1](x, shift)
                    for desc, f in functions[1:]:
                        with self.subTest(edit=desc, x=x, shift=shift):
                            self.assertEqual(f(x, shift), want)


if __name__ == '__main__':
    unittest.main()
