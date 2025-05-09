const { spawn } = require('child_process');
const commands = [
	{ bin: '/nodejs/bin/node', args: ['packages/prisma/node_modules/.bin/prisma', 'migrate', 'deploy'] },
	{ bin: '/nodejs/bin/node', args: ['apps/web/node_modules/.bin/next', 'start'] },
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
	} catch (error) {
		console.error('Error:', error);
	}
};
start();