const sharp = require("sharp");
const fs = require("fs");

const inputFilePath = "test.heif";
const inputBuffer = fs.readFileSync(inputFilePath);

const formatMemoryUsage = (data) =>
  `${Math.round((data / 1024 / 1024) * 100) / 100} MB`;

let count = 0;

function logMemoryUsage() {
  const memoryData = process.memoryUsage();

  const memoryUsage = {
    rss: `${formatMemoryUsage(
      memoryData.rss
    )} -> Resident Set Size - total memory allocated for the process execution`,
    heapTotal: `${formatMemoryUsage(
      memoryData.heapTotal
    )} -> total size of the allocated heap`,
    heapUsed: `${formatMemoryUsage(
      memoryData.heapUsed
    )} -> actual memory used during the execution`,
    external: `${formatMemoryUsage(memoryData.external)} -> V8 external memory`,
  };

  console.log(memoryUsage);
  count++;
}

const processImage = async () => {
  try {
    await sharp(inputBuffer)
      .withMetadata({ density: 300 })
      .toBuffer();

    clearInterval(intervalId);
    console.log("Time Taken : ", count, " seconds");
  } catch (err) {
    clearInterval(intervalId);
    console.log("Error => ", err);
  }
};

const intervalId = setInterval(logMemoryUsage, 1000);
processImage();
