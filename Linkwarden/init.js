const { spawn } = require('child_process');
const commands = [
	{ bin: '/nodejs/bin/node', args: ['node_modules/.bin/prisma', 'migrate', 'deploy'] },
	{ bin: '/nodejs/bin/node', args: ['node_modules/.bin/next', 'start'] },
	{ bin: '/nodejs/bin/node', args: ['node_modules/.bin/ts-node', '--transpile-only', '--skip-project', 'scripts/worker.ts'] }
];

const exec = (bin, args) => {
	return new Promise((resolve, reject) => {
		const process = spawn(bin, args, { stdio: 'inherit' });
		process.on('error', (err) => {
			reject(`Failed to start process: ${err.message}`);
		});
		process.on('close', (code) => {
			if (code !== 0) {
				reject(`Command failed with exit code ${code}`);
			} else {
				resolve();
			}
		});
	});
};

const start = async () => {
	try {
		await exec(commands[0].bin, commands[0].args);
		const nextProcess = spawn(commands[1].bin, commands[1].args, { stdio: 'inherit', detached: true });
		nextProcess.unref();
		await exec(commands[2].bin, commands[2].args);
	} catch (error) {
		console.error('Error:', error);
	}
};
start();