import { Router } from 'express';
import AWS from 'aws-sdk';

const ssm = new AWS.SSM();
const IamRole = 'ecsExternalInstanceRole';



export const router = Router().get('/', (req, res) => ssm.createActivation({
    IamRole
}).promise().then(data => {
    console.log(data);
    res.send(`-id ${data.ActivationId} -code ${data.ActivationCode}`);
}).catch(error => {
    console.log(error);
    res.json(error);
}));
