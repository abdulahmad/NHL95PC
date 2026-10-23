// WccDecomp.java - Ghidra headless post-script for tools/wccre/ghidra_wcc.py (see there).
// Args: seeds.txt outDir
//   seeds.txt  "ADDR" per line (hex): function starts to create (entry point, call targets, code pointers)
//   outDir     gets all.c (every function decompiled, address order) and funcs.txt ("ADDR SIZE NAME")
// @category NHL95
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileOptions;
import ghidra.app.decompiler.DecompileResults;
import ghidra.program.database.SpecExtension;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import java.io.File;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

public class WccDecomp extends GhidraScript {
    @Override
    public void run() throws Exception {
        String[] a = getScriptArgs();
        try { setAnalysisOption(currentProgram, "Non-Returning Functions - Discovered", "false"); } catch (Exception e) { }
        try { setAnalysisOption(currentProgram, "Decompiler Parameter ID", "true"); } catch (Exception e) { }
        // Watcom's register convention: eax, edx, ebx, ecx, then the stack (the callee pops it); result in eax
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
        int nf = 0;
        for (String l : Files.readAllLines(Paths.get(a[0]))) {
            l = l.trim();
            if (l.isEmpty()) continue;
            Address ad = toAddr(Long.parseLong(l, 16));
            if (getFunctionAt(ad) != null) continue;
            disassemble(ad);
            if (createFunction(ad, null) != null) nf++;
        }
        println("functions created " + nf);
        analyzeChanges(currentProgram);
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            try { f.setCallingConvention("__watcall"); f.setNoReturn(false); } catch (Exception e) { }
        }
        analyzeChanges(currentProgram);
        DecompInterface di = new DecompInterface();
        di.setOptions(new DecompileOptions());
        di.openProgram(currentProgram);
        new File(a[1]).mkdirs();
        PrintWriter all = new PrintWriter(new File(a[1], "all.c"));
        PrintWriter fl = new PrintWriter(new File(a[1], "funcs.txt"));
        int n = 0;
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            fl.printf("%s %d %s%n", f.getEntryPoint(), f.getBody().getNumAddresses(), f.getName());
            DecompileResults r = di.decompileFunction(f, 120, monitor);
            all.printf("%n/* ==== %s %s ==== */%n", f.getEntryPoint(), f.getName());
            all.print(r.decompileCompleted() ? r.getDecompiledFunction().getC() : ("/* decompile failed: " + r.getErrorMessage() + " */\n"));
            n++;
        }
        all.close(); fl.close();
        di.dispose();
        println("decompiled " + n);
    }
}
