# 
# altchip_id_avm_wrapper "Avalon-MM Slave Wrapper for Unique Chip ID" v17.0
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module altchip_id_avm_wrapper
# 
set_module_property DESCRIPTION "Avalon-MM slave wrapper for altchip_id IP"
set_module_property NAME altchip_id_avm_wrapper
set_module_property VERSION 17.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR @kimu_shu
set_module_property DISPLAY_NAME "Unique Chip ID with Avalon-MM slave interface"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altchip_id_avm_wrapper

proc quartus_synth { entityname } {
    add_fileset_file altchip_id_avm_wrapper.v VERILOG PATH altchip_id_avm_wrapper.v TOP_LEVEL_FILE
    add_fileset_file altchip_id.v VERILOG PATH "${::env(QUARTUS_ROOTDIR)}/../ip/altera/altchip_id/source/altchip_id.v"
}


# 
# parameters
# 
add_parameter DEVICE_FAMILY string
set_parameter_property DEVICE_FAMILY SYSTEM_INFO { DEVICE_FAMILY }
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY ENABLED false
set_parameter_property DEVICE_FAMILY VISIBLE false

add_parameter CLOCKFREQ integer
set_parameter_property CLOCKFREQ UNITS hertz
set_parameter_property CLOCKFREQ SYSTEM_INFO { CLOCK_RATE clock }
set_parameter_property CLOCKFREQ ENABLED false
set_parameter_property CLOCKFREQ VISIBLE false

add_parameter VALIDITY_ASSERTION string "ZERO"
set_parameter_property VALIDITY_ASSERTION DISPLAY_NAME "Validity assertion method"
set_parameter_property VALIDITY_ASSERTION ALLOWED_RANGES { "ZERO:Read chip ID as zero" "WAIT:Keep master waiting until UID become valid" "STATUS:Use status bit" }
set_parameter_property VALIDITY_ASSERTION HDL_PARAMETER true

set_module_assignment embeddedsw.CMacro.ZERO_INVALID 0
set_module_assignment embeddedsw.CMacro.WAIT_MASTER 0
set_module_assignment embeddedsw.CMacro.STATUS_BIT 0


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point chipid
# 
add_interface chipid avalon end
set_interface_property chipid addressUnits WORDS
set_interface_property chipid associatedClock clock
set_interface_property chipid associatedReset reset
set_interface_property chipid bitsPerSymbol 8
set_interface_property chipid burstOnBurstBoundariesOnly false
set_interface_property chipid burstcountUnits WORDS
set_interface_property chipid explicitAddressSpan 0
set_interface_property chipid holdTime 0
set_interface_property chipid linewrapBursts false
set_interface_property chipid maximumPendingReadTransactions 0
set_interface_property chipid maximumPendingWriteTransactions 0
set_interface_property chipid readLatency 0
set_interface_property chipid readWaitTime 0
set_interface_property chipid setupTime 0
set_interface_property chipid timingUnits Cycles
set_interface_property chipid writeWaitTime 0
set_interface_property chipid ENABLED true
set_interface_property chipid EXPORT_OF ""
set_interface_property chipid PORT_NAME_MAP ""
set_interface_property chipid CMSIS_SVD_VARIABLES ""
set_interface_property chipid SVD_ADDRESS_GROUP ""

add_interface_port chipid chipid_address address Input 1
add_interface_port chipid chipid_read read Input 1
add_interface_port chipid chipid_readdata readdata Output 32
set_interface_assignment chipid embeddedsw.configuration.isFlash 0
set_interface_assignment chipid embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment chipid embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment chipid embeddedsw.configuration.isPrintableDevice 0


# 
# connection point valid
# 
add_interface valid avalon end
set_interface_property valid addressUnits WORDS
set_interface_property valid associatedClock clock
set_interface_property valid associatedReset reset
set_interface_property valid bitsPerSymbol 8
set_interface_property valid burstOnBurstBoundariesOnly false
set_interface_property valid burstcountUnits WORDS
set_interface_property valid explicitAddressSpan 0
set_interface_property valid holdTime 0
set_interface_property valid linewrapBursts false
set_interface_property valid maximumPendingReadTransactions 0
set_interface_property valid maximumPendingWriteTransactions 0
set_interface_property valid readLatency 0
set_interface_property valid readWaitTime 0
set_interface_property valid setupTime 0
set_interface_property valid timingUnits Cycles
set_interface_property valid writeWaitTime 0
set_interface_property valid ENABLED true
set_interface_property valid EXPORT_OF ""
set_interface_property valid PORT_NAME_MAP ""
set_interface_property valid CMSIS_SVD_VARIABLES ""
set_interface_property valid SVD_ADDRESS_GROUP ""

add_interface_port valid valid_read read Input 1
add_interface_port valid valid_readdata readdata Output 32
set_interface_assignment valid embeddedsw.configuration.isFlash 0
set_interface_assignment valid embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment valid embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment valid embeddedsw.configuration.isPrintableDevice 0


# 
# Callbacks
# 
set_module_property ELABORATION_CALLBACK elaborate
proc elaborate {} {
    set validity [ get_parameter_value VALIDITY_ASSERTION ]

    switch $validity {
        "ZERO" {
            set_interface_property valid ENABLED false
            set_module_assignment embeddedsw.CMacro.ZERO_INVALID 1
        }
        "WAIT" {
            set_interface_property valid ENABLED false
            add_interface_port chipid chipid_waitrequest waitrequest Output 1
            set_module_assignment embeddedsw.CMacro.WAIT_MASTER 1
        }
        "STATUS" {
            set_interface_property valid ENABLED true
            set_module_assignment embeddedsw.CMacro.STATUS_BIT 1
        }
    }

    set clockfreq [ get_parameter_value CLOCKFREQ ]
    set max_freq 80000000
    if { $clockfreq == 0 } {
        send_message warning "Clock frequency is unknown"
    } elseif { $clockfreq > $max_freq } {
        send_message error "Maximum clock is ${max_freq} Hz"
    }
}
