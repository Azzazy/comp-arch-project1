# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.cache/wt [current_project]
set_property parent.project_path /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys-a7-100t:part0:1.0 [current_project]
set_property ip_output_repo /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/hex_data.mem
read_verilog -library xil_defaultlib {
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/defines.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/ALUControl.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/ControlUnit.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/new/DeMux1_2.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/Decoder5_32.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/new/Extender.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/FlipFlop.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/new/Forward_U.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/Full_Adder.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/ImmGen.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/Mux2_1.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/Mux4_1.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/RISCV.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/RegFile.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/RegWLoad.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/RippleAdder.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/SSDDriver.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/sources_1/imports/new/bram.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/branch_unit.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/prv32_ALU.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/shifter.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/sources_1/new/single_memory.v
  /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/sources_1/imports/p/RISCV_Top.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/constrs_1/imports/p/PackagePins.xdc
set_property used_in_implementation false [get_files /home/caffe/XilinxProjects/p1-ms3-pipe-v1/p1-ms3-pipe-v0.srcs/constrs_1/imports/p/PackagePins.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top RISCV_Top -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef RISCV_Top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file RISCV_Top_utilization_synth.rpt -pb RISCV_Top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
