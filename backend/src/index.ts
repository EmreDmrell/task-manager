import express from "express";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";

const app = express();

app.use(express.json());
app.use("/tasks", taskRouter);
app.use("/auth", authRouter);

app.get("/", (req, res) => {
  res.send("Welcome to my task app!!");
});

app.listen(8000, () => {
  console.log("Server started on port 8000");
});
