const { spawn } = require('child_process');
function runCommand(command, args) {
	const child = spawn(command, args, { stdio: 'inherit', shell: false });

	child.on('error', (err) => {
		console.error(`Error starting process: ${err.message}`);
	});

	child.on('exit', (code) => {
		console.log(`Process exited with code: ${code}`);
	});
}
runCommand('/nodejs/bin/node', ['node_modules/.bin/next', 'start']);
runCommand('/nodejs/bin/node', ['node_modules/.bin/ts-node', '--transpile-only', '--skip-project', 'scripts/worker.ts']);