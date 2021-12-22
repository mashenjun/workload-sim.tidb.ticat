set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

###

dir=`must_get_mole_collect_dir "${env}" 'true'`
reshape_config=`must_env_val "${env}" 'mole.reshape-cfg'`

input_dir="${dir}/metrics"
reshaped_dir="${dir}/reshaped"

mole_dir="${here}/../repos/mole"
mole_bin=`build_mole "${mole_dir}"`

###

reshape_rules="${mole_dir}/example/${reshape_config}"
echo "[:-] reshape begin"
"${mole_bin}" reshape \
	-i "${input_dir}" \
	-o "${reshaped_dir}" \
	--rule "${reshape_rules}"
echo "[:)] reshape done"