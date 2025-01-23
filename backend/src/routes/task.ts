import { Router } from "express";
import { authMiddleware, AuthRequest } from "../middlewares/auth_middleware";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post("/", authMiddleware, async (req: AuthRequest, res) => {
  try {
    req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
    const newTask = req.body as NewTask;

    const [task] = await db.insert(tasks).values(newTask).returning();
    res.status(201).json({ task });
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

taskRouter.get("/", authMiddleware, async (req: AuthRequest, res) => {
  try {
    const allTasks = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uid, req.user!));
    res.json(allTasks);
  } catch (error) {
    res.status(500).json({ error });
  }
});

taskRouter.delete("/", authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { taskId }: { taskId: string } = req.body;
    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.json(true);
  } catch (error) {
    res.status(500).json({ error });
  }
});

export default taskRouter;
