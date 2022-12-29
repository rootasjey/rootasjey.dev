interface CheckPostAccessControlParams {
  postId: string
  jwt: string
}

interface CheckProjectAccessControlParams {
  projectId: string
  jwt: string
}

interface CreateUserAccountParams {
  email: string;
  password: string;
  username: string;
}

interface DataUpdateParams {
  beforeData: FirebaseFirestore.DocumentData;
  afterData: FirebaseFirestore.DocumentData;
  payload: unknown;
  docId: string;
}

interface DeleteAccountParams {
  idToken: string;
}

interface DeleteCoverFilesParams {
  documentId: string;
  includePost?: boolean;
}


interface OperationIllustrationParams {
  /** Illustration's id. */
  "illustration_id": string;
}

interface GenerateImageThumbsParams {
  documentId: string;
  extension: string;
  fileName: string;
  filePath: string;
  objectMeta: functions.storage.ObjectMetadata;
  visibility: string;
}

interface GenerateImageThumbsResult {
  dimensions: ImageDimensions;
  thumbnails: ThumbnailLinks;
}

interface GetNewPostFirestorePayloadParams {
  initialContent: string
  storagePath: string
}

interface GetOpPayloadParams {
  documentData: FirebaseFirestore.DocumentData
  language: "en" | "fr"
  operationType: "create" | "delete" | "update"
  prevLanguage?: "en" | "fr"
  updateType?: "none" | "visibility" | "language"
  visibility?: "public" | "private"
}

interface Post {
    "character_count": number
    coauthors: Record<string, boolean>
    cover: {
      /** Image's extension. */
      extension: string
      "cover_width": "full" | "center"
      "cover_corner": "squared" | "rounded"
      dimensions: {
        height: number
        width: number
      },
      /** GCP/Firebase https url of the original file size. */
      "original_url": string
      /** File size of the cover image. */
      size: number
      "storage_path": string
      thumbnails: {
        xs: string
        s: string
        m: string
        l: string
        xl: string
        xxl: string
      },
    },
    "created_at": adminApp.firestore.FieldValue.serverTimestamp,
    featured: boolean
    i18n: Record<string, string>
    language: "en" | "fr"
    platforms: Record<string, boolean>
    "programming_languages": Record<string, boolean>
    "post_created_at": adminApp.firestore.FieldValue.serverTimestamp
    released: boolean
    "released_at": adminApp.firestore.FieldValue.serverTimestamp
    size: number,
    "social_links": {
      android: string
      artbooking: string
      behance: string
      bitbucket: string
      dribbble: string
      facebook: string
      github: string
      gitlab: string
      instagram: string
      ios: string
      linkedin: string
      macos: string
      other: string
      twitter: string
      website: string
      windows: string
      youtube: string
    },
    "storage_path": string
    tags: Record<string, boolean>
    "time_to_read": string
    "updated_at": adminApp.firestore.FieldValue.serverTimestamp
    visibility: "private" | "public" | "acl"
    "word_count": number
}

interface Project {
  author: {
    id: string
  }
  id: string
  name: string
  published: boolean
}

interface ThumbnailLinks {
  [key: string]: string,
  xs: string;
  s: string;
  m: string;
  l: string;
  xl: string;
  xxl: string;
}

interface UpdateEmailParams {
  newEmail: string;
  idToken: string;
}

interface UpdateGlobalDocStatsParams {
  documentName: string;
  language: "en" | "fr";
  operationType: "create" | "delete" | "update"
  prevLanguage?: "en" | "fr";
  updateType?: "none" | "visibility" | "language"
  visibility?: "public" | "private"
}

interface UpdateUsernameParams {
  newUsername: string;
}

interface UpdateUserStatsParams {
  documentName: string
  language: "en" | "fr"
  userId: string
  operationType: "create" | "delete" | "update"
  prevLanguage?: "en" | "fr";
  updateType?: "none" | "visibility" | "language"
  visibility?: "public" | "private"
}
