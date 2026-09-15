const express = require('express')

const app = express()
const DEFAULT_PORT = 3000
const port = process.env.PORT || DEFAULT_PORT

app.use(express.json())

app.get('/', (req, res) => {
    res.send('')
})

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Health check - OK' });
});

app.listen(port, () => {
    console.log(process.env)
    console.log('web app is listening on port', port)
})