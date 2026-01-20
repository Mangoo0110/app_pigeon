import User from "../model/user.model.js";
import AppError  from "../error/app_error.js";


export const register = async (req, res) => {
    const { userName, email, password} = req.body;
    if(!email || !userName) {
        throw new AppError(400, "Email and username are required");
    }
    // Check if user already exists
    let user = await User.findOne({ email });
    if (user) {
      throw new AppError(400, "User with this email already exists");
    } else {
        user = await User.findOne({ userName });
        if (user) {
          throw new AppError(400, "User with this username already exists");
        }
    }
    const newUser = new User({ userName, email, password });
    await newUser.save();
    res.status(201).json({ message: "User registered successfully" });
}