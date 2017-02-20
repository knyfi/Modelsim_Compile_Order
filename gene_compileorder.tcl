#Your ModelSim project file here
set file_name_RD "RMII_MAC.mpf"
#Your destination .do file there
set file_name_WR "compileorder.do"


#  Slurp up file to process
set fp [open $file_name_RD r]
set file_data [read $fp]
close $fp
puts "FileList: $File_List"
#  Process data file
set File_List ""
set To_Write ""

set data [split $file_data "\n"]
foreach line $data {
     # Expected Line:  Project_Files_Count = 10 
	 if {[string match "Project_Files_Count = *" $line]} {
			set FileCount [lindex [split $line "= "] 3]

			# $FileCount now stores the number of file to compile
		}	
	
	if {[string match "Project_File_*" $line]} {
			set File_List [lindex [split $line "/"] 5]
			# That "5" is the weak point of the script, it refers to the number of "/" in the absolute path of the files to compile :
			# Project_File_0 = C:/Users/myname/ModelSim_Projects/RMII_MAC/TOP_RMII_MAC.vhd
		if {$File_List ne ""} {
			append To_Write "vcom " $File_List "\n"
		}	
	}
	continue	
}

set fileWR [open $file_name_WR "w"]
puts -nonewline $fileWR "# This file should be auto-generated. Don't modify \n \n"
puts -nonewline $fileWR $To_Write
close $fileWR
