import fetch from "node-fetch"

describe('podcast api', () => {
    test('it should be able to ping', async () => {
        const req = await fetch('https://api.mobile.freecodecamp.dev/podcasts');

        expect(req.status).toEqual(200);

    })
})