if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/es4final"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- es4final_impl_1_cpe.ldc
run_engine_newmsg cpe -f "es4final_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o es4final_impl_1_cpe.ldc
# synthesize top design
file delete -force -- es4final_impl_1.vm es4final_impl_1.ldc
run_engine_newmsg synthesis -f "es4final_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o es4final_impl_1_syn.udb es4final_impl_1.vm] "Z:/es4final/impl_1/es4final_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
