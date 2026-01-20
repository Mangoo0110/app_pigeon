import { Schema } from "mongoose";
import bcrypt from "bcrypt"
import crypto from "crypto"
import { timeStamp } from "console";

const Roles = ["admin", "staff"]
const userSchema = new Schema(
    {
        userName: {type: String, required: true, unique: true, lowercase: true, trim: true},
        email: {type: String, required: true, unique: true, lowercase: true, trim: true},
        password: {type: String, required: true},
        fullName: {type: String, default: "Unknown"},
        role: {type: String, enum: Roles, required: true, default: "staff"},
        avatarUrl: {type: String, required: false},
        emailVerified: {type: Boolean, default: false},
    },
    {timeStamp: true}
);

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  const saltRounds = Number(process.env.bcrypt_salt_round) || 10;
  this.password = await bcrypt.hash(this.password, saltRounds);
  next();
});


// Instance method (user.comparePassword())
userSchema.methods.comparePassword = async function (plain) {
  // compare plain to this.password (if you hash it)
  return plain === this.password;
};

// Static method (User.findByEmail())
userSchema.statics.findByEmail = async function (email) {
  return this.findOne({ email });
};

// Static method (User.findByIdAndDelete())
userSchema.statics.findByIdAndDelete = async function (id) {
  return this.findByIdAndDelete(id);
};

const User = mongoose.model("User", userSchema);
export default User;