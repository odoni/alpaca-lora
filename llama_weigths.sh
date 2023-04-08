PRESIGNED_URL="HTTP://AGI.GPT4.ORG/LLA/LLAMA/*"

MODEL_SIZE="7B,13B,30,65B"
TARGET_FOLDER="./"

for i in ${MODEL_SIZE//,/}
do
	echo "Downloading ${i}"
	mkdir -p ${TARGET_FOLDER}"/$i"
	for s in $(seq -f "0%g" 0 ${N_SHARD_DICT[$i]})
	do
		wget ${PRESIGNED_URL/'*'/"${i}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${i}/consolidated.${s}.pth"
	done
	wget ${PRESIGNED_URL/'*'/"${i}/params.json"} -O ${TARGET_FOLDER}"/${i}/params.json"
	wget ${PRESIGNED_URL/'*'/"${i}/checklist.chk"} -O ${TARGET_FOLDER}"/${i}/checklist.chk"
	echo "Checking checksums"
	(cd ${TARGET_FOLDER}"/${i}" && md5sum -c checklist.chk)
done