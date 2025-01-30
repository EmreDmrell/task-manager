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

taskRouter.delete("/:id", authMiddleware, async (req: AuthRequest, res) => {
  try {
    const taskId = req.params.id;
    await db.delete(tasks).where(eq(tasks.id, taskId));
    res.json(true);
  } catch (error) {
    res.status(500).json({ error });
  }
});

taskRouter.post("/sync", authMiddleware, async (req: AuthRequest, res) => {
  try {
    const tasksList = req.body;

    const filteredTasks: NewTask[] = [];

    for (let t of tasksList) {
      t = {
        ...t,
        dueAt: new Date(t.dueAt),
        createdAt: new Date(t.createdAt),
        updatedAt: new Date(t.updatedAt),
        uid: req.user,
      };
      filteredTasks.push(t);
    }

    const pushedTasks = await db
      .insert(tasks)
      .values(filteredTasks)
      .returning();

    res.status(201).json(pushedTasks);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
});

taskRouter.post(
  "/sync-deleted",
  authMiddleware,
  async (req: AuthRequest, res) => {
    try {
      const tasksList = req.body;

      const deletedTaskIds: string[] = [];

      for (let t of tasksList) {
        deletedTaskIds.push(t.id);
      }

      // Delete tasks marked for unsynced deletion
      if (deletedTaskIds.length > 0) {
        for (let id of deletedTaskIds) {
          await db.delete(tasks).where(eq(tasks.id, id));
        }
      }

      res.json(true);
    } catch (error) {
      console.log(error);
      res.status(500).json({ error });
    }
  }
);
export default taskRouter;
