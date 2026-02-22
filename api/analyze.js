
      criteria = [
        {
          name: "Classroom Environment",
          description: "Creating an environment of respect and rapport, establishing a culture for learning, managing classroom procedures and student behavior"
        },
        {
          name: "Instruction",
          description: "Communicating with students, using questioning and discussion techniques, engaging students in learning, using assessment effectively"
        },
        {
          name: "Planning and Preparation",
          description: "Demonstrating knowledge of content and pedagogy, demonstrating knowledge of students, setting instructional outcomes"
        },
        {
          name: "Professional Responsibilities",
          description: "Reflecting on teaching, maintaining accurate records, communicating with families, growing professionally"
        }
      ];
    }

    const criteriaText = criteria.map((c, i) => 
      `${i + 1}. ${c.name}: ${c.description}`
    ).join('\n');

    const prompt = `You are an expert educational evaluator. Analyze this classroom observation using the specific criteria provided.

OBSERVATION DETAILS:
Teacher: ${teacherName}
Subject/Grade: ${subject || 'Not specified'}
Department: ${department || 'Not specified'}
Grade Level: ${gradeLevel || 'Not specified'}
Observation Type: ${observationType || 'Not specified'}

OBSERVATION NOTES:
${notes}

EVALUATION CRITERIA:
${criteriaText}

Provide a detailed analysis in this EXACT JSON format (no markdown, no extra text):

{
  "criteria": [
    ${criteria.map(c => `{
      "name": "${c.name}",
      "rating": "High/Proficient/Developing/Needs Improvement",
      "evidence": "Specific evidence from the observation notes",
      "explanation": "2-3 sentence explanation of the rating"
    }`).join(',\n    ')}
  ],
  "insights": {
    "strengths": ["Strength 1", "Strength 2", "Strength 3"],
    "growthAreas": ["Growth area 1", "Growth area 2"],
    "recommendations": ["Specific recommendation 1", "Specific recommendation 2", "Specific recommendation 3"]
  },
  "summary": "A 2-3 sentence overall summary of the observation"
}

Return ONLY valid JSON. No markdown formatting.`;

    const anthropic = new Anthropic({
      apiKey: process.env.CLAUDE_API_KEY,
    });

    const message = await anthropic.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 2500,
      messages: [{ role: 'user', content: prompt }]
    });

    let responseText = message.content[0].text;
    responseText = responseText.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error('No JSON found in AI response');
    }

    const analysis = JSON.parse(jsonMatch[0]);

    return res.status(200).json({
      success: true,
      analysis: analysis,
      criteriaUsed: criteria,
      metadata: {
        teacherName,
        subject,
        department,
        gradeLevel,
        observationType,
        timestamp: new Date().toISOString()
      }
    });

  } catch (error) {
    console.error('Analysis error:', error);
    return res.status(500).json({ 
      error: error.message || 'Failed to analyze observation',
      details: error.toString()
    });
  }
}
