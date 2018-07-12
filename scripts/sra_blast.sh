#/bin/bash

set -x # for debuging

# FIXME: MAKE cancer type dynamic
Cancer_Type="AML"
Species_Type="Homo sapiens"

DATADIR="data"

HERV_INPUT_DB="${DATADIR}/herv/herv_ref_135.fasta"
HERV_OUTPUT_DB="${DATADIR}/herv/retro_virus_db"

# Create DIRECTORY for Cancer Type
mkdir -p "${DATADIR}/${Cancer_Type}"

# Create Results sub-directory
RESULTS_DIR="${DATADIR}/${Cancer_Type}/results"
mkdir -p "${RESULTS_DIR}"

# Create working sub-directory
WORKING_DIR="${DATADIR}/${Cancer_Type}/working"
mkdir -p "${WORKING_DIR}"

# FILENAMES for intermediate results
EFETCH_FILE="${WORKING_DIR}/${Cancer_Type}_efetch.txt"
RUN_ID_FILE="${WORKING_DIR}/${Cancer_Type}_run_id.txt"
PARALLEL_CMD_FILE="${WORKING_DIR}/magicblast_commands.txt"

OUTPUT_EXT="_res.sam"

Query_String="$Cancer_Type[All Fields] AND \"$Species_Type\"[orgn] AND (cluster_public[prop] AND \"biomol rna\"[Properties])"

# Make the blast db 
# FIXME: Should only be done once and not per Cancer_Type
makeblastdb -in $HERV_INPUT_DB -out "${HERV_OUTPUT_DB}" -parse_seqids -dbtype nucl

# Get the metadata from SRA archive
esearch -db sra -query "${Query_String}"  | efetch -format runinfo  > "${EFETCH_FILE}"

# Filter the metadata so that we remove headers and also cell lines
cat "${EFETCH_FILE}" | grep -v '^$' \
       | grep -v '^Run' \
       | grep -iv "cell line" \
       | grep -i "${Cancer_Type}" \
       | awk -F',' '{print $1}' > "${RUN_ID_FILE}"


# Pick up all the resulting Run ID's and put it into an array
run_ids_array=(`cat "${RUN_ID_FILE}"`)

# Create a parallel command file
echo -n "" > "${PARALLEL_CMD_FILE}"

# We have one command for each Run ID and we run them sequentially
for run_id in "${run_ids_array[@]}"
do
   echo "$run_id"
   magicblast -sra "${run_id}"  -db "${HERV_OUTPUT_DB}" -no_discordant \
	   -num_threads 4 -no_unaligned -out "${RESULTS_DIR}/${run_id}_res.sam" 
done

