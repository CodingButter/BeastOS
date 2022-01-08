const fs = require("fs")
const args = process.argv
const rootFile = args[2]
const buildName = args[3]
const buildStructure = []

const findRequires = code =>{
    const rexp = /require\(([^)]+)\)/g;
    let matches = code.match(rexp) || []
    matches = matches.map(v=>"."+v.replace("require(\"/disk","").replace("\")",""))
    return matches
}

const readFile = path => {
    let code = fs.readFileSync(`${path}.lua`,{encoding:'utf8', flag:'r'})
    return code
}

const addCode = (path) =>{
    let code = readFile(path)
    let requires = findRequires(code)
    requires.forEach((r)=>{
        if(buildStructure.filter(f=>f.path==r).length==0){
            console.log(r)
            addCode(r)
        }
    })
    code = `
    -- [[ ${path} ]]

    ` + code
    let codeObject = {
        path,
        code
    }
    buildStructure.push(codeObject)
}
addCode(rootFile)

const build = buildStructure.map(({code})=>code).join("\n")
fs.writeFileSync(`${buildName}.lua`,build)
