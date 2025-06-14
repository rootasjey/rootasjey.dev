export interface Pagination {
  hasNext: boolean
  hasPrev: boolean
  limit: number
  page: number
  total: number
  totalPages: number
}
