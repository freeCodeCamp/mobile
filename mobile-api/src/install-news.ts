const fs = require('fs');
const path = require('path');

const { exec } = require('child_process');

function installGhost() {

    if(!fs.existsSync(path.join(__dirname, 'news'))){
        fs.mkdir(path.join(__dirname, 'news'),  (error: string) => {
            if (error) {
                console.log(error);
            }
            console.log('news directory made successfully!');
        });

        exec('npm install ghost-cli@latest -g', (error: string , stdout: string, stderr: string) => {

            if(error){
                console.log(`error: ${error}`);
                return;
            }
    
            if(stderr) {
                console.log(`error: ${error}`);
                return;
            }
    
            console.log(`stdout: ${stdout}`);
        });
    
        exec('ghost install local', {cwd: path.join(__dirname, "/news")}, (error: string , stdout: string, stderr: string) => {
    
            if(error){
                console.log(`error: ${error}`);
                return;
            }
    
            if(stderr) {
                console.log(`error: ${error}`);
                return;
            }
    
            console.log(`stdout: ${stdout}`);
        });
    }


}

function runGhost(){
    exec('ghost start', {cwd: path.join(__dirname, "/news")},  (error: string , stdout: string, stderr: string) => {

        if(error){
            console.log(`error: ${error}`);
            return;
        }

        if(stderr) {
            console.log(`error: ${error}`);
            return;
        }

        console.log(`stdout: ${stdout}`);
    });
}
installGhost();
runGhost();
