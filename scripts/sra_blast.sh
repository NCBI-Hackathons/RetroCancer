#/bin/bash

display_help () {

cat << EOF
Usage: ./scripts/sra_blast.sh -c cancertype [OPTIONS] [FILE]...
Takes a cancer Type and blasts against a reference HERV database

Mandatory arguments to long options are mandatory for short options too.

  -c, --cancertype  type of cancer to look for in SRA (Mandatory arg)
  -g, --greppattern pattern to grep for after metadata is downloaded
		    (default is to grep for cancer type)
  -d, --datadir     Data directory to read from
  -f, --hervdb      Fasta file to use for HERV database
  -h, --help        give this help
  -v, --verbose     verbose mode

Report bugs to <Olaitan Awe>.
EOF

}

while :
do
    case "$1" in
      -c | --cancertype)
          Cancer_Type="$2"
          shift 2
          ;;
      -g | --greppattern)
          Grep_Pattern="$2"
          shift 2
          ;;
      -f | --hervdb)
          HERV_INPUT_DB="$2"
          shift 2
          ;;
      -d | --datadir)
          DATADIR="$2"
          shift 2
      -h | --help)
          display_help
          # no shifting needed here, we're done.
          exit 0
          ;;
      -v | --verbose)
          verbose="verbose"
          shift
          ;;
      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1
          ;;
      *)  # No more options
          break
          ;;
    esac
done

if [ -n "$verbose" ]
  then
    set -x
fi

if [ -z "$Cancer_Type" ]
  then
    echo "No cancer type supplied"
  exit 1
fi

# If we do not have a grep pattern then we set it to Cancer Type
if [ -z "$Grep_Pattern"]
  then
    Grep_Pattern="$Cancer_Type"
fi

if [ -z "$DATADIR"]
  then
    DATADIR="data"
fi

if [ -z "$HERV_INPUT_DB"]
  then
    HERV_INPUT_DB="${DATADIR}/herv/Hsap38.geve.nt_v1.fa"
fi
HERV_OUTPUT_DB="${DATADIR}/herv/retro_virus_db"


Species_Type="Homo sapiens"


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
       | grep -i "${Grep_Pattern}" \
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

