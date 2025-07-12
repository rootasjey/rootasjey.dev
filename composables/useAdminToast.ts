// Admin-specific toast notifications composable

export const useAdminToast = () => {

  const showSuccess = (message: string, title?: string) => {
    toast({
      title: title || 'Success',
      description: message,
      toast: 'success',
      leading: 'i-ph-check-circle',
      duration: 5000
    })
  }

  const showError = (message: string, title?: string) => {
    toast({
      title: title || 'Error',
      description: message,
      toast: 'error',
      leading: 'i-ph-warning-circle',
      duration: 8000
    })
  }

  const showWarning = (message: string, title?: string) => {
    toast({
      title: title || 'Warning',
      description: message,
      toast: 'warning',
      leading: 'i-ph-warning',
      duration: 6000
    })
  }

  const showInfo = (message: string, title?: string) => {
    toast({
      title: title || 'Info',
      description: message,
      toast: 'info',
      leading: 'i-ph-info',
      duration: 5000
    })
  }

  // Admin-specific notifications
  const showCreateSuccess = (itemType: string, itemName?: string) => {
    const message = itemName 
      ? `${itemType} "${itemName}" has been created successfully.`
      : `${itemType} has been created successfully.`
    showSuccess(message, `${itemType} Created`)
  }

  const showUpdateSuccess = (itemType: string, itemName?: string) => {
    const message = itemName 
      ? `${itemType} "${itemName}" has been updated successfully.`
      : `${itemType} has been updated successfully.`
    showSuccess(message, `${itemType} Updated`)
  }

  const showDeleteSuccess = (itemType: string, itemName?: string) => {
    const message = itemName 
      ? `${itemType} "${itemName}" has been deleted successfully.`
      : `${itemType} has been deleted successfully.`
    showSuccess(message, `${itemType} Deleted`)
  }

  const showBulkSuccess = (action: string, count: number, itemType: string) => {
    const message = `${count} ${itemType}${count === 1 ? '' : 's'} ${action} successfully.`
    showSuccess(message, `Bulk ${action.charAt(0).toUpperCase() + action.slice(1)}`)
  }

  const showApiError = (error: any, context?: string) => {
    let message = 'An unexpected error occurred. Please try again.'
    
    if (error?.data?.message) {
      message = error.data.message
    } else if (error?.message) {
      message = error.message
    } else if (typeof error === 'string') {
      message = error
    }

    const title = context ? `${context} Error` : 'Error'
    showError(message, title)
  }

  const showValidationError = (errors: Record<string, string[]>) => {
    const errorMessages = Object.values(errors).flat()
    const message = errorMessages.length > 1 
      ? `Please fix the following errors:\n• ${errorMessages.join('\n• ')}`
      : errorMessages[0]
    
    showError(message, 'Validation Error')
  }

  const showPermissionError = () => {
    showError(
      'You do not have permission to perform this action.',
      'Permission Denied'
    )
  }

  const showNetworkError = () => {
    showError(
      'Unable to connect to the server. Please check your internet connection and try again.',
      'Network Error'
    )
  }

  return {
    showSuccess,
    showError,
    showWarning,
    showInfo,
    showCreateSuccess,
    showUpdateSuccess,
    showDeleteSuccess,
    showBulkSuccess,
    showApiError,
    showValidationError,
    showPermissionError,
    showNetworkError
  }
}
