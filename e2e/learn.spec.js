import { expect, test } from "@playwright/test";

// These are all in the freeCodeCamp repo. That repo is installed alongside this
// repo in CI. i.e. the structure is:
//
// workspace-root/freeCodeCamp
// workspace-root/mobile

import currData from "../../freeCodeCamp/shared-dist/config/curriculum.json";
import { orderedSuperBlockInfo } from "../../freeCodeCamp/tools/scripts/build/build-external-curricula-data-v2";
import { SuperBlocks } from "../../freeCodeCamp/shared/config/curriculum";

// non editor superblocks should be skipped because they are not
// checked if they are compatible with the mobile app.

const nonEditorSB = [
  SuperBlocks.PythonForEverybody,
  SuperBlocks.DataAnalysisPy,
  SuperBlocks.MachineLearningPy,
  SuperBlocks.CollegeAlgebraPy,
  SuperBlocks.A2English,
  SuperBlocks.B1English,
  SuperBlocks.TheOdinProject,
];

const publicSB = orderedSuperBlockInfo
  .filter((sb) => sb.public === true && !nonEditorSB.includes(sb.dashedName))
  .map((sb) => sb.dashedName);

const removeCertSuperBlock = (currData) => {
  const copy = currData;
  delete copy["certifications"];
  return copy;
};

const typedCurriculum = removeCertSuperBlock(currData);

test.describe("Test challenges in mobile", () => {
  for (const superBlock of publicSB) {
    for (const currBlock of Object.values(
      typedCurriculum[superBlock]["blocks"]
    )) {
      test.describe(`SuperBlock: ${superBlock} - Block: ${currBlock["meta"]["name"]}`, () => {
        for (const currChallenge of currBlock["challenges"]) {
          // Skip non-editor challenges
          if (![0, 1, 5, 6, 14].includes(currChallenge["challengeType"])) {
            continue;
          }

          test(`Challenge: ${currChallenge["title"]}(${currChallenge["id"]})`, async ({
            page,
          }) => {
            const logMsges = [];
            page.on("console", (msg) => {
              logMsges.push(msg.text());
            });
            await page.goto(
              `/generated-tests/${superBlock}/${currChallenge["block"]}/${currChallenge["id"]}`
            );

            const iframeElement = await page.waitForSelector('iframe');

            const frame = await iframeElement.contentFrame();

            await frame.waitForLoadState('load');

            expect(logMsges).toContain("completed");
          });
        }
      });
    }
  }
});
