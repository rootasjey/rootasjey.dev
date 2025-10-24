# Documents System - Resumes & Cover Letters

## 📚 Overview

This system provides a clean, database-driven approach to managing multiple resumes (CVs) and cover letters. It replaces the previous approach of having separate `.vue` files for each document with a template-based system backed by a database.

## 🏗️ Architecture

### **Database Tables**
- `resumes` - Stores CV data with JSON fields for flexible content
- `cover_letters` - Stores cover letter data with TipTap HTML content
- Relations: Cover letters can be linked to specific resumes

### **Key Features**
- ✅ Multiple resume variants (technical, communication, creative)
- ✅ Template-based rendering (easy to add new templates)
- ✅ Structured JSON data for most content
- ✅ Rich text editor (TipTap) for cover letters
- ✅ Automatic linking between CVs and letters
- ✅ Published/unpublished states
- ✅ Multi-language support (EN/FR)

## 🚀 Getting Started

### **Step 1: Run Database Migration**

The migration file has been created at:
```
server/database/migrations/0002_add_documents.sql
```

NuxtHub will automatically run this migration when you:
1. Deploy to production, or
2. Run `npx nuxthub database migrations apply` locally

### **Step 2: Seed Initial Data**

To populate the database with your existing CV and letter data:

1. Make sure you're logged in as an admin
2. Send a POST request to `/api/documents/seed`

```bash
# Using curl (when logged in)
curl -X POST http://localhost:3000/api/documents/seed

# Or use a tool like Postman/Insomnia
```

This will create:
- 3 resumes (general, communication, community manager)
- 2 cover letters (Maurepas, Montigny-le-Bretonneux)

### **Step 3: Access Your Documents**

**View all documents:**
- Navigate to `/documents`
- Lists all published CVs and letters

**View individual documents:**
- CV: `/documents/cv/[slug]` (e.g., `/documents/cv/cv`)
- Letter: `/documents/letters/[slug]` (e.g., `/documents/letters/lettre-maurepas`)

## 📂 File Structure

```
components/
  documents/
    CVTemplate.vue           # Default CV template
    LetterTemplate.vue       # Default letter template
    DocumentCard.vue         # Card component for listings

pages/
  documents/
    index.vue                # List all documents
    cv/
      [slug].vue             # Dynamic CV viewer
    letters/
      [slug].vue             # Dynamic letter viewer

server/
  api/
    documents/
      resumes/
        index.get.ts         # List all resumes
        index.post.ts        # Create resume
        [slug].get.ts        # Get single resume
        [slug].put.ts        # Update resume
      letters/
        index.get.ts         # List all letters
        index.post.ts        # Create letter
        [slug].get.ts        # Get single letter
        [slug].put.ts        # Update letter
      seed.post.ts           # Seed script
  database/
    migrations/
      0002_add_documents.sql # Database schema
  utils/
    document.ts              # Data transformation utilities

types/
  document.d.ts              # TypeScript type definitions
```

## 🔧 Creating New Documents

### **Via API (Programmatic)**

**Create a new resume:**
```typescript
const resume = await $fetch('/api/documents/resumes', {
  method: 'POST',
  body: {
    slug: 'cv-creative',
    title: 'Creative Developer CV',
    subtitle: 'Designer & Developer',
    type: 'creative',
    language: 'en',
    templateName: 'default',
    name: 'Jérémie Corpinot',
    tagline: 'Creative Developer',
    location: 'France',
    profile: {
      text: 'I am a creative developer...'
    },
    skills: {
      categories: [
        { title: 'Design', skills: ['Figma', 'Photoshop'] }
      ]
    },
    experiences: [...],
    published: true
  }
})
```

**Create a new cover letter:**
```typescript
const letter = await $fetch('/api/documents/letters', {
  method: 'POST',
  body: {
    slug: 'lettre-startup',
    title: 'Cover Letter - Startup XYZ',
    companyName: 'Startup XYZ',
    position: 'Frontend Developer',
    language: 'en',
    templateName: 'default',
    greeting: 'Dear Hiring Manager,',
    body: '<p>I am writing to...</p><p>...</p>',
    closing: 'Best regards,',
    signature: 'Jérémie Corpinot',
    resumeId: 1, // Link to a specific CV
    published: true
  }
})
```

## 🎨 Adding New Templates

To create a new resume template:

1. **Create template component:**
```vue
<!-- components/documents/templates/cv/ModernTemplate.vue -->
<template>
  <div class="modern-cv">
    <!-- Your custom layout -->
    <h1>{{ cv.name }}</h1>
    <!-- ... -->
  </div>
</template>

<script setup lang="ts">
import type { Resume } from '~/types/document'
defineProps<{ cv: Resume }>()
</script>
```

2. **Update dynamic loader:**
```vue
<!-- pages/documents/cv/[slug].vue -->
<script setup>
const templates = {
  'default': defineAsyncComponent(() => import('~/components/documents/CVTemplate.vue')),
  'modern': defineAsyncComponent(() => import('~/components/documents/templates/cv/ModernTemplate.vue')),
}

const templateComponent = computed(() => 
  templates[cv.value?.templateName] || templates.default
)
</script>

<template>
  <component :is="templateComponent" :cv="cv" />
</template>
```

3. **Use the new template:**
```typescript
// Set template_name when creating/updating
{
  templateName: 'modern'
}
```

## 🔗 Linking CVs and Letters

Cover letters can reference a resume via `resumeId`:

```typescript
const letter = await $fetch('/api/documents/letters', {
  method: 'POST',
  body: {
    // ... other fields
    resumeId: 1, // Links to resume with ID 1
  }
})
```

The letter template will automatically show a link to the associated CV in the footer.

## 📝 Next Steps (Optional Enhancements)

### **Admin UI** (Future)
Create admin pages for CRUD operations:
- `/admin/documents/resumes` - Manage resumes
- `/admin/documents/letters` - Manage letters
- Use TipTap editor for letter editing (similar to post editor)

### **PDF Export** (Future)
- Generate PDF versions of CVs/letters
- Store in Blob storage
- Add download buttons

### **Version History** (Future)
- Track changes over time
- Ability to restore previous versions

## 🛠️ Maintenance

### **Updating Existing Documents**

```typescript
// Update a resume
await $fetch(`/api/documents/resumes/${slug}`, {
  method: 'PUT',
  body: {
    // Fields to update
    title: 'Updated Title',
    published: true
  }
})
```

### **Database Queries**

```sql
-- View all resumes
SELECT * FROM resumes;

-- View all cover letters with linked resume titles
SELECT cl.*, r.title as resume_title 
FROM cover_letters cl
LEFT JOIN resumes r ON cl.resume_id = r.id;

-- Find unpublished documents
SELECT * FROM resumes WHERE published = 0;
SELECT * FROM cover_letters WHERE published = 0;
```

## 🎯 Migration from Old System

The old CV files (`pages/cv.vue`, `pages/cv-com.vue`, etc.) can remain in place as fallbacks. Once you've verified the new system works:

1. Run the seed script to populate data
2. Test all documents at `/documents`
3. Update any links pointing to old URLs
4. Optionally remove old files

### **URL Mapping**

| Old URL | New URL |
|---------|---------|
| `/cv` | `/documents/cv/cv` |
| `/cv-com` | `/documents/cv/cv-communication` |
| `/cv-com-2` | `/documents/cv/cv-community-manager` |
| `/lettre-com` | `/documents/letters/lettre-maurepas` |
| `/lettre-com-2` | `/documents/letters/lettre-montigny` |

You can add redirects in `nuxt.config.ts` if needed.

## 💡 Tips

1. **Use descriptive slugs:** Makes URLs cleaner and more memorable
2. **Keep templates simple:** Start with one template, add more as needed
3. **JSON structure:** Allows easy querying and filtering without parsing HTML
4. **Published flag:** Draft documents before making them public
5. **Linking:** Associate letters with CVs for better organization

## 🆘 Troubleshooting

**Documents not showing?**
- Check `published` flag is set to `true`
- Verify you're logged in if viewing unpublished docs
- Check database has been migrated

**Seed script fails?**
- Ensure you're logged in as admin
- Check database connection
- Look for constraint violations (duplicate slugs)

**Template not found?**
- Verify `template_name` matches available templates
- Check component imports are correct
- Fallback to 'default' template if needed

---

**Happy documenting! 📄✨**
