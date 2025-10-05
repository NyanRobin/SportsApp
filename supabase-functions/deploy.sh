#!/bin/bash

# FieldSync Supabase Deployment Script
# This script deploys the FieldSync backend to Supabase

set -e

echo "🚀 Starting FieldSync Supabase Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    print_error "Supabase CLI is not installed. Please install it first:"
    echo "npm install -g supabase"
    echo "or"
    echo "brew install supabase/tap/supabase"
    exit 1
fi

print_success "Supabase CLI found"

# Check if we're in the right directory
if [ ! -f "supabase/config.toml" ]; then
    print_error "supabase/config.toml not found. Please run this script from the supabase-functions directory."
    exit 1
fi

# Login to Supabase (if not already logged in)
print_status "Checking Supabase authentication..."
if ! supabase projects list &> /dev/null; then
    print_status "Please log in to Supabase..."
    supabase login
fi

print_success "Authenticated with Supabase"

# Ask for project configuration
read -p "Enter your Supabase project reference (from dashboard URL): " PROJECT_REF

if [ -z "$PROJECT_REF" ]; then
    print_error "Project reference is required"
    exit 1
fi

# Link to Supabase project
print_status "Linking to Supabase project: $PROJECT_REF"
supabase link --project-ref "$PROJECT_REF"

print_success "Linked to project"

# Deploy database schema
print_status "Deploying database schema and migrations..."
supabase db push

print_success "Database schema deployed"

# Deploy Edge Functions
print_status "Deploying Edge Functions..."

# Deploy users function
print_status "Deploying users function..."
supabase functions deploy users --no-verify-jwt

# Deploy games function
print_status "Deploying games function..."
supabase functions deploy games --no-verify-jwt

# Deploy announcements function
print_status "Deploying announcements function..."
supabase functions deploy announcements --no-verify-jwt

# Deploy statistics function
print_status "Deploying statistics function..."
supabase functions deploy statistics --no-verify-jwt

# Deploy activities function
print_status "Deploying activities function..."
supabase functions deploy activities --no-verify-jwt

print_success "All Edge Functions deployed"

# Set up environment variables (if .env file exists)
if [ -f ".env" ]; then
    print_status "Setting up environment variables..."
    
    # Read environment variables from .env file and set them in Supabase
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        if [[ $key =~ ^[[:space:]]*# ]] || [[ -z $key ]]; then
            continue
        fi
        
        # Remove quotes from value
        value=$(echo "$value" | sed 's/^"//;s/"$//')
        
        print_status "Setting $key..."
        supabase secrets set "$key=$value" --project-ref "$PROJECT_REF"
    done < .env
    
    print_success "Environment variables configured"
else
    print_warning ".env file not found. Please set up environment variables manually in Supabase dashboard."
fi

# Generate types for TypeScript
print_status "Generating TypeScript types..."
supabase gen types typescript --local > types/database.types.ts

print_success "TypeScript types generated"

# Display deployment information
echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📋 Deployment Summary:"
echo "├── Project: $PROJECT_REF"
echo "├── Database: Schema and migrations deployed"
echo "├── Edge Functions: 5 functions deployed"
echo "│   ├── users"
echo "│   ├── games" 
echo "│   ├── announcements"
echo "│   ├── statistics"
echo "│   └── activities"
echo "└── Types: Generated for TypeScript"
echo ""
echo "🔗 Your Edge Functions are available at:"
echo "https://$PROJECT_REF.supabase.co/functions/v1/"
echo ""
echo "📱 Next steps:"
echo "1. Update your Flutter app with the new Supabase URL"
echo "2. Test the API endpoints"
echo "3. Configure Row Level Security policies if needed"
echo "4. Set up real-time subscriptions"
echo ""
print_success "FieldSync backend is now live on Supabase! 🚀"


