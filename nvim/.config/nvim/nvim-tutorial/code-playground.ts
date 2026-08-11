type User={id:number;name:string;email?:string}

export function formatUser(user:User):string{
const label=user.email?`${user.name} <${user.email}>`:user.name
return `${user.id}: ${label}`
}

export function findUser(users:User[],id:number){return users.find((user)=>user.id===id)}

const users:User[]=[{id:1,name:"Ada",email:"ada@example.test"},{id:2,name:"Grace"}]
console.log(formatUser(users[0]))

// Intentional diagnostics for LSP testing:
const definitelyNumber:number="not a number"
console.log(missingIdentifier)

// TELESCOPE_NEEDLE TypeScript fixture
