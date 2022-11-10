#!/usr/bin/env bun run

// Add this to your shell config
// alias tmp='cd $(~/dot-config/bins/tmp/tmp.ts)'

import { join } from "path";
import { mkdirSync } from "fs";
import * as randomWords from "random-words";

const [a, b] = randomWords(2);

const dir = join("/tmp", a + "-" + b);

mkdirSync(dir);
console.log(dir);
