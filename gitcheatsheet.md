# 1️⃣ Initialize local Git repository
cd path/to/projectgb
git init

# 2️⃣ Stage and commit all files
git add .
git commit -m "Initial commit: Flask app + Dockerfile + cheatsheet"

# 3️⃣ Add SSH remote
git remote add origin git@github.com:<your-username>/projectgb.git

# 4️⃣ Check remote URL
git remote -v

# 5️⃣ Test SSH connection to GitHub
ssh -T git@github.com

# 6️⃣ Push code to GitHub (main branch)
git push -u origin main

# 7️⃣ Future updates
git add .
git commit -m "Describe your change"
git push
