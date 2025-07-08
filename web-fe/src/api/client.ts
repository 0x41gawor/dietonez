import axios from 'axios'

const client = axios.create({
  baseURL: 'http://192.46.236.119:8080/api/v1',
  headers: {
    'Content-Type': 'application/json'
  }
})

export default client