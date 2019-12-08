let project = new Project('BulletsSuction');
project.addAssets('res/**', {
	nameBaseDir: 'res',
	destination: '{dir}/{name}',
	name: '{dir}/{name}'
});
project.addSources('src');
project.addShaders('src/shaders/**');
project.addParameter('-dce full'); 
project.addParameter('-D analyzer-optimize');
project.targetOptions.html5.disableContextMenu = true;
resolve(project);
