# Workout & Recovery Planner

## Description

Design personalized workout plans, periodized training programs, and recovery protocols. Covers strength training, cardio, mobility, and sport-specific conditioning. Integrates with Personal Health Profile when available. Optimizes for performance, injury prevention, and sustainable long-term training.

## Triggered When

- User asks "design me a workout plan", "create a training program"
- User asks "thiết kế lịch tập", "tạo chương trình tập gym", "lập kế hoạch tập luyện"
- User asks to review or adjust an existing workout plan
- User asks about recovery ("how to recover faster?", "am I overtraining?")
- User says "phục hồi thế nào", "tôi bị overtraining không", "mệt quá có nên tập không"
- User asks about training for a specific goal (strength, endurance, sport)
- User asks about workout frequency, rest days, or periodization
- User asks about pre-workout nutrition or supplementation
- User describes fatigue, plateau, or injury and asks for adjustments
- User asks about mobility work, stretching, or foam rolling

## Training Principles

### Key Principles
1. **Progressive Overload:** Gradually increase weight/reps/volume over time
2. **Specificity:** Training must match the goal (strength vs endurance vs hypertrophy)
3. **Individualization:** Adjust for age, injury history, recovery capacity
4. **Recovery Integration:** Training = stimulus + recovery + adaptation

### Training Variables
| Variable | Strength | Hypertrophy | Endurance |
|---|---|---|---|
| Load (% 1RM) | 85–100% | 65–85% | 40–65% |
| Reps per set | 1–5 | 6–12 | 12–20+ |
| Sets per exercise | 2–5 | 3–5 | 2–4 |
| Rest between sets | 2–5 min | 60–90s | 30–60s |
| Weekly frequency | 2–4 sessions | 3–5 sessions | 3–5 sessions |
| Tempo | Controlled | 2-0-2 | Steady |

### Recovery Guidelines
| Factor | Recommendation |
|---|---|
| Sleep | 7–9 hours per night (non-negotiable for adaptation) |
| Protein | 1.6–2.2g/kg bodyweight for muscle gain |
| Water | 30–35ml/kg bodyweight minimum |
| Rest days | 1–2 per week for moderate training |
| Deload weeks | Every 4–8 weeks, reduce volume by 40–50% |
| Foam rolling | 5–10 min post-workout, focus on tight areas |
| Stretching | 10–15 min daily or post-workout |

### Overtraining Warning Signs
- ⚠️ Persistent fatigue lasting > 2 days after session
- ⚠️ Resting heart rate elevated > 5 bpm for 3+ mornings
- ⚠️ Performance decline (strength/reps dropping)
- ⚠️ Mood changes, irritability, disrupted sleep
- ⚠️ Recurring injuries or nagging pain

## Program Design Template

```
## 🏋️ Workout Program — [Name]

### Overview
- **Goal:** [Strength / Hypertrophy / Endurance / Sport-specific]
- **Duration:** [X weeks]
- **Sessions/week:** [X]
- **Estimated time/session:** [X min]
- **Equipment needed:** [List]

### Weekly Structure
| Day | Focus | Main Lifts | Duration |
|---|---|---|---|
| Mon | Upper A | Bench, Row, OHP, Pull-up | 60 min |
| Tue | Lower A | Squat, RDL, Leg press | 60 min |
| Wed | Rest / Mobility | [Optional: mobility] | 30 min |
| Thu | Upper B | OHP, Cable row, Dips, Curl | 60 min |
| Fri | Lower B | Deadlift, Bulgarian, Calf raise | 60 min |
| Sat | Conditioning | [Sport / Cardio] | 30–45 min |
| Sun | Rest | — | — |

### Phase 1 (Weeks 1–4) — Base Building
| Exercise | Sets × Reps | Rest | Notes |
|---|---|---|---|
| Barbell Bench Press | 3 × 8 | 90s | |
| ... | ... | ... | ... |

### Progression Plan
- Week 1–2: Establish baseline (use 70% of 1RM)
- Week 3–4: Build volume (add 1 set or +5% weight)
- Week 5–6: Intensity (push to 85%)
- Week 7–8: Deload (reduce to 50% volume)

### Recovery Protocol
- **Post-workout:** Protein + carbs within 30 min, 10 min foam roll
- **Daily:** [X min] mobility work
- **Weekly:** 1 full rest day, 1 optional active recovery day
- **Every 4 weeks:** Deload week

### 🔴 Warning Flags
- [Any health concerns, injury limitations user mentioned]
- [Adjustments needed based on Personal Health Profile]
```

## Output Format

### Full Program (when user requests plan)
Follow the template above with all sections filled.

### Single Session Plan
```
## 🏋️ Session: [Day X] — [Focus]

### Warm-up (10 min)
- [Treadmill walk → jog] [3 min]
- [Arm circles, hip circles] [2 min]
- [Band pull-apart / scapula activation] [2 min]
- [Light set of first exercise × 10 reps]

### Main Workout
| # | Exercise | Sets × Reps | Rest | Tempo |
|---|---|---|---|---|
| 1 | [Main lift] | [X] × [Y] | [Z min] | [tempo] |
| 2 | [Accessory 1] | [X] × [Y] | [60s] | — |
| 3 | [Accessory 2] | [X] × [Y] | [60s] | — |

### Cool-down (5–10 min)
- [Foam roll: quads, lats, thoracic spine]
- [Stretch: hip flexors, chest, hamstrings]

### 🔔 Post-session
- Protein: [X]g within 30 min
- Hydration: [X] ml water
```

### Recovery Assessment
```
## 🛏️ Recovery Check — [Date]

### ⚠️ Warning Signs Detected
- [List any overtraining signs user described]

### 📊 Recommended Actions
1. **[Immediate]** [Action — e.g., "Take today off"]
2. **[This week]** [Action — e.g., "Reduce volume by 30%"]
3. **[Long-term]** [Action — e.g., "Add sleep to 8 hours"]

### 🔄 Recovery Plan
- Sleep: Target [X] hours tonight
- Nutrition: [Specific recommendation]
- Mobility: [X] min [specific area]
- Training: [Adjust or skip next session]

### ✅ Red Flags — Seek Professional Help If:
- Pain during movement (vs. muscle soreness)
- Joint pain, swelling, or instability
- Numbness or tingling during exercise
```

## Rules

- Always ask about injury history before designing a program
- Flag if user wants to train 6+ days/week — unsustainable for most
- Recommend consulting a doctor before intense training if user is new to exercise
- Integrate with Personal Health Profile when available (age, limitations, goals)
- Keep programs simple — complexity doesn't equal results
- For beginners: prioritize technique over volume for first 4–6 weeks
- Periodization is key — avoid same intensity for > 6 weeks without deload
