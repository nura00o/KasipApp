import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import admin from "firebase-admin";
import User from "./models/User.js";
import fs from "fs";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

if(process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    admin.initizializeApp({
        credential:admin.credential.applictionDefault(),
    });
}else if(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64) {
    const json=JSON.parse(
        Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64,'base64').toString('utf-8'));

    admin.initializeApp({
        credential:admin.credential.cert(json),
    });
}else{
    console.error('');
    process.exit(1);
}

const {MONGODB_URL, PORT = 3000} = process.env;
mongoose
.connect(MONGODB_URL)
.then(()=>console.log('Connected to MongoDB'))
.catch((err)=>{
    console.error('MongoDB connection error:', err);
    process.exit(1);
});
// async function verifyFirebaseToken(req, res, next) {
//   const auth = req.headers.authorization || "";
//   const [, token] = auth.split(" ");

//   if (!token) return res.status(401).json({ ok: false, message: "No token" });

//   try {
//     const decoded = await admin.auth().verifyIdToken(token);
//     req.firebase = decoded;
//     next();
//   } catch (e) {
//     return res.status(401).json({ ok: false, message: "Invalid token", error: e.message });
//   }
// }
app.post('/api/auth/ensureUser', async (req, res) => {
    const {uid,email,name,picture} = {
        uid: req.firebase.uid,
        email: req.firebase.email ||null,
        // name: req.firebase.name || null,
        // picture: req.firebase.picture || null,
    };
    try{
        const user = await User.findByIdAndUpdate(
            {uid},
            {
                $setOnInsert: {uid},
                $set:{email},
            },
            {upsert:true, new:true});
        return res.json({ok:true, user});
    }catch(err){
        return res.status(500).json({ok:false, message:'Сервермен қате'})

    }
});
app.get('/api/profile', async(req,res)=>{
    try{
        const user = await User.findById(req.firebase.uid);
        if (!user) return res.status(404).json({ok:false, message:'Пайдаланушы табылмады'});
        return res.json({ok:true, user});
    }catch(err){
        return res.status(500).json({ok:false, message:'Сервермен қате'});
    }
})
app.listen(PORT, () => {
    console.log(`${PORT} портында сервер іске қосылды`);
});