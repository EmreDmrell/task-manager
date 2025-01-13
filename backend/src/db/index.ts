import { Pool } from "pg";
import { drizzle } from "drizzle-orm/node-postgres";
import postgres from "postgres";
import * as schema from "./schema";
import dotenv from "dotenv";
dotenv.config();
// Create the postgres connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Create the drizzle database instance
export const db = drizzle(pool);
