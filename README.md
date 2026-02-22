# SightLine Backend API

Complete backend with AI analysis, collaboration, customizable criteria, and feedback generation.

## API Endpoints

- `/api/analyze` - AI analysis with custom criteria
- `/api/generate-feedback` - AI-generated teacher feedback messages
- `/api/observations` - Save/retrieve with filtering
- `/api/comments` - Collaboration system
- `/api/criteria` - Customizable frameworks
- `/api/insights` - School-wide analytics

## Features

- Multi-user collaboration
- Comments and discussions
- Advanced filtering (date, teacher, department, observer, tags)
- Customizable evaluation criteria
- AI-generated feedback for teachers
- School-wide insights

## Deployment (Via GitHub + Vercel Dashboard)

### Step 1: Upload to GitHub

1. Go to https://github.com/morris00/sightline-backend
2. Click "Add file" > "Upload files"
3. Drag the `api` folder (if not already there)
4. Commit changes

### Step 2: Deploy on Vercel

1. Go to https://vercel.com/dashboard
2. Find your sightline-backend project
3. It should auto-deploy when you update GitHub
4. Wait for "Ready" status

### Step 3: Add Environment Variables

In Vercel dashboard:

1. Go to Settings > Environment Variables
2. Add these 3 variables:

- `CLAUDE_API_KEY` = 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
- `SUPABASE_URL` = https://bppulkeekgfiarapfcaq.supabase.co
- `SUPABASE_ANON_KEY` = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJwcHVsa2Vla2dmaWFyYXBmY2FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk5OTM0MTUsImV4cCI6MjA4NTU2OTQxNX0.X9neBjEKwgikAV6jKibsGrwz02fMtmeGzkHLf61W-lA

3. Redeploy after adding variables

### Step 4: Test

Visit: https://your-url.vercel.app/api/analyze

You should see: {"error":"Method not allowed"}

This is correct - the API is working.

## Database Setup

Run `database-setup.sql` in Supabase SQL Editor.

Save your school_id and user_id when prompted.

## Support

If you encounter issues, check:
- Environment variables are set in Vercel
- Database tables are created in Supabase
- API endpoints return expected errors (not 404)
