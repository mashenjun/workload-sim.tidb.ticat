set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`


## Build mole
#
build_mole "${here}/../repos/mole"
bin="${here}/../repos/mole/bin/mole"

## Dirs and reshap rule file
#
input_dir=`must_env_val "${env}" 'mole.input'`
output_dir=`must_env_val "${env}" 'mole.output'`

mkdir -p "${input_dir}"
mkdir -p "${output_dir}"

reshape_rules_yaml=`env_val "${env}" 'mole.rules'`
if [ ! -f "${reshape_rules_yaml}" ]; then
	if [ -f "${here}/reshape_rules.yaml" ]; then
		reshape_rules_yaml="${here}/reshape_rules.yaml"
		echo "[:-] use default reshape_rules.yaml"
	else
		echo "[:(] can't find '${reshape_rules_yaml}'" >&2
		exit 1
	fi
fi

## check if output dir already contain reshaped metrics
#
if [ "$(ls -A $output_dir)" ]; then
     echo "[:-] reshaped metrics already exist"
     exit 0
fi

## Reshape metrics json to csv
#
reshape_cmd="${bin} reshape \
	-i ${input_dir} \
	-o ${output_dir} \
	--rule ${reshape_rules_yaml}"

echo "${reshape_cmd}"
echo "[:-] reshape metrics begin"
${reshape_cmd}
echo "[:)] reshape metrics done"

