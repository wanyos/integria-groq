
const URL_BACKEND = "http://localhost:8155"

export const setPost = async (query: string) => {
    try {
        const endpoint = "/query"
        const res = await fetch(`${URL_BACKEND}${endpoint}`, {
            method: 'POSt',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ question: query })
        })
        if (!res.ok) {
            const errorData = await res.json()
            throw new Error(errorData.error || 'Request failed')
        }
        const response = await res.json()
        return response
    } catch (error: unknown) {
        console.log('Error in fetch setPost', error)
    }
}