export interface User {
  username: string;
  email: string;
  password: string;
  id?: RecordId;
  [key: string]: any
}
