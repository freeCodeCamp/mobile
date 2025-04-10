async function testThis() {
  const runner = await window.FCCSandbox.createTestRunner({
    source: "def someFun():\\n  return 5\\n",
    type: "python",
    assetPath: "/",
    code: {
      contents: "'hello'",
    },
  });
  const result = await runner.runTest(`({
  test: () => assert.equal(runPython('someFun()'), 5)
})`);
  console.log(JSON.stringify(result));
}
