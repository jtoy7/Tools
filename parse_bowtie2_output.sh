#!/bin/bash

# create list of .err files from bowtie jobs to loop over
ls *hologenome_mapping*.err > errfile_list.txt

# create data file and add header if it is empty
header="sample\tconcordantly_0_times\tconcordantly_1_time\tconcordantly_2_or_more_times\toverall_rate" #assign header value
outfile="bowtie_mapping_summary.tsv"

if [ ! -s "$outfile" ]; then
  # file is empty or does not exist
        echo -e "$header" > "$outfile"
fi

for FILE in `cat errfile_list.txt`; do
        # parse mapping rates from botwtie2 otuput
        jobid=$(echo $FILE | cut -d "_" -f1,2)
        sample=$(head -3 $jobid'_hologenome_mapping_array_pver_pilot_2024-08-02.out' | tail -1)
        con0=$(grep -oP '\d+\.\d+%?' $jobid'_hologenome_mapping_array_pver_pilot_2024-08-02.err' | head -2 | tail -1)
        con1=$(grep -oP '\d+\.\d+%?' $jobid'_hologenome_mapping_array_pver_pilot_2024-08-02.err' | head -3 | tail -1)
        con2=$(grep -oP '\d+\.\d+%?' $jobid'_hologenome_mapping_array_pver_pilot_2024-08-02.err' | head -4 | tail -1)
        overall=$(grep -oP '\d+\.\d+%? overall alignment rate' $jobid'_hologenome_mapping_array_pver_pilot_2024-08-02.err' | cut -d" " -f1)

        # Append data to output file
        echo -e "$sample\t$con0\t$con1\t$con2\t$overall" >> "$outfile"

done
