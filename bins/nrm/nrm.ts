const start = performance.now();
export async function ensureDir(dir: string): Promise<void> {
  try {
    const fileInfo = await Deno.lstat(dir);
    if (!fileInfo.isDirectory) {
      throw new Error(`Ensure path exists, expected 'dir''`);
    }
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      // if dir not exists. then create it.
      await Deno.mkdir(dir, { recursive: true });
      return;
    }
    throw err;
  }
}
await ensureDir("node_modules"); // this is a bit silly
await ensureDir("/tmp/n");
await Deno.rename("node_modules", `/tmp/n/${Math.random()}`);
console.log("Done in " + performance.now() + " milliseconds.");
