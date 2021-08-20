set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`

## Python script
#
script="${here}/../repos/mole/data-analysis/prom_metrics_feature_score.py"
conda=`must_env_val "${env}" 'conda.bin'`

## Dirs and feature functions setting file
#
input_dir=`must_env_val "${env}" 'mole.input'`
output=`must_env_val "${env}" 'mole.output'`

mkdir -p "${input_dir}"

feature_function_yaml=`env_val "${env}" 'mole.feature_function'`
if [ ! -f "${feature_function_yaml}" ]; then
	if [ -f "${here}/feature_function.yaml" ]; then
		feature_function_yaml="${here}/feature_function.yaml"
		echo "[:-] use default feature_function.yaml"
	else
		echo "[:(] can't find '${feature_function_yaml}'" >&2
		exit 1
	fi
fi

## Reshape metrics json to csv
#
score_cmd="${conda} run -n workload-sim python3 ${script} \
	-i ${input_dir} \
	-o ${output} \
	-f ${feature_function_yaml}"

echo "${score_cmd}"
echo "[:-] calculate score begin"
${score_cmd}
echo "[:)] calculate score done"

