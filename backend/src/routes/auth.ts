import { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

const authRouter = Router();
const jwt_key = process.env.JWT_KEY;

interface RegisterBody {
  username: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

authRouter.post(
  "/register",
  async (req: Request<{}, {}, RegisterBody>, res: Response) => {
    try {
      // get the body
      const { username, email, password } = req.body;

      // check if the user already exists
      const existingUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email));
      if (existingUser.length) {
        res
          .status(400)
          .json({ error: "User with the same email already exists" });
        return;
      }

      // hash the password
      const hashedPassword = await bcryptjs.hash(password, 10);

      // create the user
      const newUser: NewUser = {
        username,
        email,
        password: hashedPassword,
      };

      const [user] = await db.insert(users).values(newUser).returning();
      res.status(201).json(user);
    } catch (error) {
      res.status(500).json({ error: error });
    }
  }
);

authRouter.post(
  "/login",
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
      //get request body
      const { email, password } = req.body;

      // check if the user does not exist
      const [existingUser] = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (!existingUser) {
        res.status(400).json({ error: "User with this email does not exist" });
        return;
      }

      const isMatch = await bcryptjs.compare(password, existingUser.password);

      if (!isMatch) {
        res.status(400).json({ error: "Incorrect Password" });
        return;
      }

      if (!jwt_key) {
        res.status(500).json({ error: "JWT_KEY is not defined" });
        return;
      }
      const token = jwt.sign({ id: existingUser.id }, jwt_key);

      res.json({ token, ...existingUser });
    } catch (error) {
      res.status(500).json({ error });
    }
  }
);

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    //get the header
    const token = req.header("x-auth-token");

    if (!token) {
      res.json(false);
      return;
    }

    // verify if the token is valid
    if (!jwt_key) {
      res.status(500).json({ error: "JWT_KEY is not defined" });
      return;
    }
    const verified = jwt.verify(token, jwt_key);

    if (!verified) {
      res.json(false);
      return;
    }

    // get the user data if the token is valid

    const verifiedToken = verified as { id: string };

    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.json(false);
      return;
    }

    res.json(true);
  } catch (error) {
    res.status(500).json(false);
  }
});

export default authRouter;
