set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`

## Python script
#
script="${here}/../repos/mole/data-analysis/prom_metrics_feature_score_distance.py"
conda=`must_env_val "${env}" 'conda.bin'`

## Dirs and feature functions setting file
#
base=`must_env_val "${env}" 'mole.base'`
target=`must_env_val "${env}" 'mole.target'`
output=`must_env_val "${env}" 'mole.output'`
## Reshape metrics json to csv
#
score_distance_cmd="${conda} run -n workload-sim python3 ${script} \
	-b ${base} \
	-t ${target} \
	-o ${output}"

echo "${score_distance_cmd}"
echo "[:-] calculate score distance begin"
${score_distance_cmd}
echo "[:)] calculate score distance done"

