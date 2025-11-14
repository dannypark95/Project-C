# MVP Architecture & Data Model

## Secret Sauce: What Makes This Unique

### 1. **Relationship Context Awareness**

- AI understands **couple dynamics**, not just individual emotions
- Recognizes relationship patterns (pursuer-distancer, blame cycles, etc.)
- Provides relationship-specific insights

### 2. **Conflict Cycle Detection**

- Identifies repeating patterns: "Every time X happens, you feel Y, then Z occurs"
- Maps the cycle: Trigger → Emotion → Reaction → Partner's Response → Escalation
- Breaks the cycle with targeted interventions

### 3. **Emotion-Needs Mapping**

- Connects emotions to underlying needs
- Example: "Anger" → Need for "Respect" or "Understanding"
- Helps users express needs instead of just emotions

### 4. **Non-Violent Communication Framework**

- Built-in NVC structure: Observation → Feeling → Need → Request
- AI helps reframe: "You always..." → "When X happens, I feel..."
- Real-time communication coaching

### 5. **Pattern Recognition Across Time**

- Learns from multiple conversations
- Identifies: "This is the 3rd time this week you've mentioned feeling ignored"
- Predicts triggers before they escalate

---

## MVP Features (Phase 1: Nov-Dec 2025)

### Core Features to Build:

1. **Relationship-Aware AI Chat** ✅ (Partially done)

   - Current: Basic chat with Aura
   - Add: Relationship context, conflict detection, pattern recognition

2. **Emotion & Needs Analysis**

   - Extract emotions from conversations
   - Identify underlying needs (validation, security, respect, etc.)
   - Track patterns over time

3. **Conflict Pattern Recognition**

   - Detect recurring conflict cycles
   - Identify trigger words/situations
   - Show relationship patterns visually

4. **Communication Guidance**

   - Suggest non-violent communication phrases
   - Help reframe conversations
   - Provide relationship-specific coaching

5. **Simple Emotion Tracking**
   - Track emotions during conflicts
   - Show emotion trends
   - Link emotions to relationship events

---

## Unique Database Model

### Current Structure (Too Simple):

```
users/
  └── {userId}/
      └── messages/
          └── {messageId}
```

### Proposed Structure (Relationship-Focused):

```
users/
  └── {userId}/
      ├── profile/
      │   ├── relationshipStatus: "in_relationship" | "single"
      │   ├── partnerId: {partnerUserId} (optional, if linked)
      │   └── relationshipStartDate: Date
      │
      ├── conversations/
      │   └── {conversationId}/
      │       ├── messages/
      │       ├── emotions: [emotion1, emotion2, ...]
      │       ├── needs: [need1, need2, ...]
      │       ├── conflictDetected: boolean
      │       └── conflictType: "blame_cycle" | "pursuer_distancer" | ...
      │
      ├── emotions/
      │   └── {emotionId}/
      │       ├── type: "anger" | "sadness" | "anxiety" | ...
      │       ├── intensity: 1-10
      │       ├── trigger: "partner_ignored_me"
      │       ├── underlyingNeed: "respect" | "understanding" | ...
      │       ├── timestamp: Date
      │       └── context: "discussion_about_finances"
      │
      ├── conflictPatterns/
      │   └── {patternId}/
      │       ├── patternType: "blame_cycle" | "pursuer_distancer" | ...
      │       ├── frequency: number
      │       ├── triggers: ["money", "time", ...]
      │       ├── firstDetected: Date
      │       ├── lastOccurred: Date
      │       └── interventions: [intervention1, ...]
      │
      ├── communicationTraining/
      │   └── {sessionId}/
      │       ├── type: "nvc_practice" | "reframing" | ...
      │       ├── completed: boolean
      │       ├── score: number
      │       └── feedback: string
      │
      └── insights/
          └── {insightId}/
              ├── type: "pattern_detected" | "progress_made" | ...
              ├── message: string
              ├── timestamp: Date
              └── actionable: boolean

relationships/ (if both partners use app)
  └── {relationshipId}/
      ├── partner1Id: {userId}
      ├── partner2Id: {userId}
      ├── sharedInsights: [...]
      ├── conflictHistory: [...]
      └── progressMetrics: {...}
```

---

## AI Model Enhancements

### Current: Basic Chat

- Simple conversation
- Language detection
- Basic empathy

### MVP: Relationship-Aware AI

1. **Emotion Extraction**

   - Analyze text for emotions
   - Map to emotion categories
   - Detect intensity

2. **Needs Identification**

   - Extract underlying needs from emotions
   - NVC framework: "I feel X because I need Y"
   - Suggest needs-based communication

3. **Pattern Detection**

   - Track recurring themes
   - Identify conflict cycles
   - Recognize trigger patterns

4. **Relationship Dynamics**

   - Understand couple patterns
   - Detect pursuer-distancer dynamics
   - Identify blame cycles

5. **Intervention Suggestions**
   - Suggest NVC reframing
   - Provide communication templates
   - Offer emotion regulation techniques

---

## MVP User Flow

1. **User opens app** → Relationship context setup (optional)
2. **User chats about conflict** → AI analyzes:
   - Emotions detected
   - Needs identified
   - Conflict pattern recognized
3. **AI provides insights**:
   - "I notice you're feeling [emotion] because you need [need]"
   - "This is similar to a pattern we've seen before..."
   - "Try reframing this as: [NVC suggestion]"
4. **User practices** → Communication training module
5. **Progress tracking** → See patterns over time, improvements

---

## Key Differentiators

1. **Relationship-Focused** (not individual wellness)
2. **Pattern Recognition** (learns from history)
3. **Actionable Interventions** (not just listening)
4. **NVC Framework** (structured communication)
5. **Conflict Cycle Breaking** (proactive, not reactive)

---

## Technical Implementation Priority

### Phase 1 (MVP - Nov-Dec 2025):

1. ✅ Basic chat (done)
2. ⏳ Emotion extraction from conversations
3. ⏳ Needs identification
4. ⏳ Simple pattern detection
5. ⏳ NVC reframing suggestions

### Phase 2 (Jan-Feb 2026):

1. Conflict cycle visualization
2. Communication training modules
3. Progress tracking dashboard
4. Partner linking (if both use app)

### Phase 3 (Mar-Nov 2026):

1. Digital biomarkers integration
2. Real-time trigger detection
3. Advanced pattern recognition
4. Professional therapist integration
