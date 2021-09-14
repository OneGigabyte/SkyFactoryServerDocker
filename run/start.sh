#!/bin/bash
dir=/config/minecraft

function accept_eula() {
	if [ ! -f "$dir/eula.txt" ]; then

		echo "[info] Starting Minecraft Java process to force creation of 'eula.txt'..."
		start_minecraft

		echo "[info] Waiting for Minecraft Java process to abort (expected, due to eula flag not set)..."
		while pgrep -fu "root" "java" > /dev/null; do
			sleep 0.1
		done
		echo "[info] Minecraft Java process ended (expected)"

	fi

	echo "[info] Checking EULA is set to 'true'..."
	cat "$dir/eula.txt" | grep -q 'eula=true'

	if [ "${?}" -eq 0 ]; then
		echo "[info] EULA set to 'true'"
	else
		echo "[info] EULA set to 'false', changing to 'true'..."
		sed -i -e 's~eula=false~eula=true~g' "$dir/eula.txt"
	fi

}

function start_minecraft() {

	# create logs sub folder to store screen output from console
	mkdir -p /config/minecraft/logs

	# run screen attached to minecraft (daemonized, non-blocking) to allow users to run commands in minecraft console
	echo "[info] Starting Minecraft Java process..."
	screen -L -Logfile '/config/minecraft/logs/screen.log' -d -S minecraft -m bash -c "cd /config/minecraft && ./ServerStart.sh"
	echo "[info] Minecraft Java process is running"
	if [[ ! -z "${STARTUP_CMD}" ]]; then
		startup_cmd
	fi

}

function startup_cmd() {

	# split comma separated string into array from STARTUP_CMD env variable
	IFS=',' read -ra startup_cmd_array <<< "${STARTUP_CMD}"

	# process startup cmds in the array
	for startup_cmd_item in "${startup_cmd_array[@]}"; do
		echo "[info] Executing startup Minecraft command '${startup_cmd_item}'"
		screen -S minecraft -p 0 -X stuff "${startup_cmd_item}^M"
	done

}

# if minecraft server.properties file doesnt exist then copy default to host config volume
if [ ! -f "$dir/server.properties" ]; then

	echo "[info] Minecraft server.properties file doesnt exist, copying default installation to '/config/minecraft/'..."

	mkdir -p "$dir"
	if [[ -d "/srv/minecraft" ]]; then
		cp -R /srv/minecraft/* /config/minecraft/ 2>/dev/null || true
	fi

else

	# rsync options defined as follows:-
	# -r = recursive copy to destination
	# -l = copy source symlinks as symlinks on destination
	# -t = keep source modification times for destination files/folders
	# -p = keep source permissions for destination files/folders
	echo "[info] Minecraft folder '/config/minecraft' already exists, rsyncing newer files..."
	rsync -rltp --exclude 'world' --exclude '/server.properties' --exclude '/*.json' /srv/minecraft/ /config/minecraft
 
fi

accept_eula

start_minecraft

bash /root/webui.sh