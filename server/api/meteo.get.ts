export default defineEventHandler(async (event) => {
  // Get query parameters with Paris as default
  const query = getQuery(event);
  const latitude = query.latitude || 48.8588255;
  const longitude = query.longitude || 2.2646342;

  try {
    // Call Open-Meteo API
    const response = await fetch(
      `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,weather_code,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto`
    );
    
    if (!response.ok) {
      throw new Error(`Weather API responded with status: ${response.status}`);
    }
    
    const data = await response.json();
    
    // Map weather codes to conditions
    // Based on WMO Weather interpretation codes (WW)
    // https://open-meteo.com/en/docs
    const getCondition = (code: number) => {
      if (code <= 1) return { text: "Clear sky", icon: "sun" };
      if (code <= 3) return { text: "Partly cloudy", icon: "cloud-sun" };
      if (code <= 49) return { text: "Fog", icon: "cloud-fog" };
      if (code <= 59) return { text: "Drizzle", icon: "cloud-drizzle" };
      if (code <= 69) return { text: "Rain", icon: "cloud-rain" };
      if (code <= 79) return { text: "Snow", icon: "cloud-snow" };
      if (code <= 99) return { text: "Thunderstorm", icon: "cloud-lightning" };
      return { text: "Unknown", icon: "question" };
    };

    // Format the response to match our expected structure
    return {
      current: {
        temp_c: data.current.temperature_2m,
        condition: getCondition(data.current.weather_code),
        is_day: data.current.is_day,
      },
      forecast: {
        forecastday: data.daily.time.slice(1, 4).map((date: string | number | Date, index: number) => ({
          date: new Date(date).toLocaleDateString('en-US', { weekday: 'short' }),
          day: {
            avgtemp_c: (data.daily.temperature_2m_max[index + 1] + data.daily.temperature_2m_min[index + 1]) / 2,
            condition: getCondition(data.daily.weather_code[index + 1])
          }
        }))
      }
    };
  } catch (error) {
    console.error('Error fetching weather data:', error);
    
    // Return mock data as fallback
    return {
      current: {
        temp_c: 22,
        is_day: 1,
        condition: {
          text: "Sunny",
          icon: "sun"
        }
      },
      forecast: {
        forecastday: [
          {
            date: "Tomorrow",
            day: {
              avgtemp_c: 24,
              condition: {
                text: "Partly cloudy",
                icon: "cloud-sun"
              }
            }
          },
          {
            date: "Wed",
            day: {
              avgtemp_c: 19,
              condition: {
                text: "Rain",
                icon: "cloud-rain"
              }
            }
          },
          {
            date: "Thu",
            day: {
              avgtemp_c: 25,
              condition: {
                text: "Sunny",
                icon: "sun"
              }
            }
          }
        ]
      }
    };
  }
});
