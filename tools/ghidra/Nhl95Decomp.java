// Nhl95Decomp.java - Ghidra headless post-script for tools/ghidra_decomp.py (see there).
// Args: data.bin dataBaseHex labels.txt funcs.txt targets.txt outDir sigs.txt
//   data.bin   the LE data object, added as a block at dataBaseHex (the code object is the imported program)
//   labels.txt "ADDR name" per line (hex): every known label, code and data
//   funcs.txt  "ADDR name" per line: the functions to create (every __CHK function)
//   targets.txt "ADDR name" per line: the functions to decompile into outDir/<name>.c
// @category NHL95
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileOptions;
import ghidra.app.decompiler.DecompileResults;
import ghidra.program.database.SpecExtension;
import ghidra.program.model.data.*;
import ghidra.program.model.listing.ParameterImpl;
import ghidra.program.model.listing.ReturnParameterImpl;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.mem.MemoryBlock;
import ghidra.program.model.symbol.SourceType;
import ghidra.program.model.symbol.SymbolTable;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class Nhl95Decomp extends GhidraScript {
    private List<String[]> rows(String path) throws Exception {
        List<String[]> out = new ArrayList<>();
        for (String l : Files.readAllLines(Paths.get(path))) {
            String[] p = l.trim().split("\\s+");
            if (p.length >= 2) out.add(p);
        }
        return out;
    }

    private DataType type(String t) {
        switch (t) {
            case "void": return VoidDataType.dataType;
            case "char": return CharDataType.dataType;
            case "uchar": return UnsignedCharDataType.dataType;
            case "short": return ShortDataType.dataType;
            case "ushort": return UnsignedShortDataType.dataType;
            case "uint": return UnsignedIntegerDataType.dataType;
            case "ptr": return new PointerDataType(VoidDataType.dataType);
            case "cptr": return new PointerDataType(CharDataType.dataType);
            case "ucptr": return new PointerDataType(UnsignedCharDataType.dataType);
            case "sptr": return new PointerDataType(ShortDataType.dataType);
            case "iptr": return new PointerDataType(IntegerDataType.dataType);
            default: return IntegerDataType.dataType;
        }
    }

    @Override
    public void run() throws Exception {
        String[] a = getScriptArgs();
        Memory mem = currentProgram.getMemory();
        byte[] data = Files.readAllBytes(Paths.get(a[0]));
        Address dbase = toAddr(Long.parseLong(a[1], 16));
        if (mem.getBlock(dbase) == null) {
            MemoryBlock b = mem.createInitializedBlock("data", dbase, new ByteArrayInputStream(data), data.length, monitor, false);
            b.setRead(true); b.setWrite(true); b.setExecute(false);
        }
        // __CHK and friends return: without this, Ghidra marks them non-returning and stops disassembling after
        // every prologue
        try { setAnalysisOption(currentProgram, "Non-Returning Functions - Discovered", "false"); } catch (Exception e) { }
        try { setAnalysisOption(currentProgram, "Decompiler Parameter ID", "true"); } catch (Exception e) { }
        // Watcom's register convention: eax, edx, ebx, ecx, then the stack (the callee pops it); result in eax;
        // every other register preserved
        new SpecExtension(currentProgram).addReplaceCompilerSpecExtension(
            "<prototype name=\"__watcall\" extrapop=\"unknown\" stackshift=\"4\">" +
            "<input><pentry minsize=\"1\" maxsize=\"4\"><register name=\"EAX\"/></pentry>" +
            "<pentry minsize=\"1\" maxsize=\"4\"><register name=\"EDX\"/></pentry>" +
            "<pentry minsize=\"1\" maxsize=\"4\"><register name=\"EBX\"/></pentry>" +
            "<pentry minsize=\"1\" maxsize=\"4\"><register name=\"ECX\"/></pentry>" +
            "<pentry minsize=\"1\" maxsize=\"500\" align=\"4\"><addr offset=\"4\" space=\"stack\"/></pentry></input>" +
            "<output><pentry minsize=\"1\" maxsize=\"4\"><register name=\"EAX\"/></pentry></output>" +
            "<unaffected><register name=\"EBX\"/><register name=\"ECX\"/><register name=\"EDX\"/><register name=\"ESI\"/>" +
            "<register name=\"EDI\"/><register name=\"EBP\"/><register name=\"ESP\"/></unaffected></prototype>", monitor);
        // __CHK: push N / call __CHK; it pops N and keeps every register
        new SpecExtension(currentProgram).addReplaceCompilerSpecExtension(
            "<prototype name=\"__chk\" extrapop=\"8\" stackshift=\"4\">" +
            "<input><pentry minsize=\"1\" maxsize=\"4\"><addr offset=\"4\" space=\"stack\"/></pentry></input>" +
            "<output><pentry minsize=\"1\" maxsize=\"4\"><register name=\"EAX\"/></pentry></output>" +
            "<unaffected><register name=\"EAX\"/><register name=\"EBX\"/><register name=\"ECX\"/><register name=\"EDX\"/>" +
            "<register name=\"ESI\"/><register name=\"EDI\"/><register name=\"EBP\"/><register name=\"ESP\"/></unaffected></prototype>", monitor);
        SymbolTable st = currentProgram.getSymbolTable();
        int nl = 0;
        for (String[] p : rows(a[2])) {
            try { st.createLabel(toAddr(Long.parseLong(p[0], 16)), p[1], SourceType.IMPORTED); nl++; } catch (Exception e) { }
        }
        for (ghidra.program.model.symbol.Symbol s : st.getGlobalSymbols("__CHK")) {
            Address ad = s.getAddress();
            Function f = getFunctionAt(ad);
            if (f == null) { disassemble(ad); f = createFunction(ad, "__CHK"); }
            if (f != null) {
                f.setCallingConvention("__chk"); f.setNoReturn(false);
                f.setReturnType(VoidDataType.dataType, SourceType.IMPORTED);
            }
        }
        int nf = 0;
        for (String[] p : rows(a[3])) {
            Address ad = toAddr(Long.parseLong(p[0], 16));
            if (getFunctionAt(ad) != null) continue;
            disassemble(ad);
            if (createFunction(ad, p[1]) != null) nf++;
        }
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            if (f.getName().equals("__CHK")) continue;
            try { f.setCallingConvention("__watcall"); f.setNoReturn(false); } catch (Exception e) { }
        }
        // the known signatures (sigs.txt: name, convention, return type, parameter types; see ghidra_decomp.py)
        int ns = 0;
        for (String l : Files.readAllLines(Paths.get(a[6]))) {
            String[] p = l.split("\t", -1);
            if (p.length < 4) continue;
            for (Function f : getGlobalFunctions(p[0])) {
                try {
                    List<ParameterImpl> ps = new ArrayList<>();
                    int k = 0;
                    if (!p[3].isEmpty())
                        for (String t : p[3].split(";")) ps.add(new ParameterImpl("a" + (k++), type(t), currentProgram));
                    ReturnParameterImpl ret = new ReturnParameterImpl(type(p[2]), currentProgram);
                    f.updateFunction(p[1], ret, ps, Function.FunctionUpdateType.DYNAMIC_STORAGE_ALL_PARAMS, true, SourceType.IMPORTED);
                    ns++;
                } catch (Exception e) { println("signature " + p[0] + ": " + e.getMessage()); }
            }
        }
        println("signatures " + ns);
        println("labels " + nl + ", functions " + nf);
        analyzeChanges(currentProgram);
        DecompInterface di = new DecompInterface();
        di.setOptions(new DecompileOptions());
        di.openProgram(currentProgram);
        new File(a[5]).mkdirs();
        for (String[] p : rows(a[4])) {
            Address ad = toAddr(Long.parseLong(p[0], 16));
            Function f = getFunctionAt(ad);
            if (f == null) { disassemble(ad); f = createFunction(ad, p[1]); }
            if (f == null) { println("no function at " + p[0] + " " + p[1]); continue; }
            DecompileResults r = di.decompileFunction(f, 300, monitor);
            String c = r.decompileCompleted() ? r.getDecompiledFunction().getC() : ("/* decompile failed: " + r.getErrorMessage() + " */\n");
            Files.write(Paths.get(a[5], p[1] + ".c"), c.getBytes());
            println("decompiled " + p[1]);
        }
        di.dispose();
    }
}
