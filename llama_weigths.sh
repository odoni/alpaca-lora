PRESIGNED_URL="https://agi.gpt4.org/llama/LLaMA/*"

MODEL_SIZE="7B,13B,30B,65B"
TARGET_FOLDER="./weights"

declare -A N_SHARD_DICT

N_SHARD_DICT["7B"]="0"
N_SHARD_DICT["13B"]="1"
N_SHARD_DICT["30B"]="3"
N_SHARD_DICT["65B"]="7"

for i in ${MODEL_SIZE//,/ }
do
	echo "Downloading ${i}"
	mkdir -p ${TARGET_FOLDER}"/${i}"
	for s in $(seq -f "0%g" 0 ${N_SHARD_DICT[$i]})
	do
		echo "URL: "${PRESIGNED_URL/'*'/"${i}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${i}/consolidated.${s}.pth"
		wget ${PRESIGNED_URL/'*'/"${i}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${i}/consolidated.${s}.pth"
	done
	wget ${PRESIGNED_URL/'*'/"${i}/params.json"} -O ${TARGET_FOLDER}"/${i}/params.json"
	wget ${PRESIGNED_URL/'*'/"${i}/checklist.chk"} -O ${TARGET_FOLDER}"/${i}/checklist.chk"
	echo "Checking checksums"
	(cd ${TARGET_FOLDER}"/${i}" && md5sum -c checklist.chk)
done