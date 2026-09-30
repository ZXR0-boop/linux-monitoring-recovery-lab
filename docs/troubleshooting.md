# Troubleshooting Notes

This project was as much about diagnosing failures as it was about building workflows. These are several of the issues I worked through.

## 1. Availability monitor showed the wrong result

### Symptom

A controlled application-stop test did not initially produce the expected DOWN state.

### Investigation

The failure test forced me to check what the monitor was actually targeting instead of assuming the configuration was correct.

### Resolution

The monitoring target was corrected and the controlled stop test then produced the expected DOWN state. After the service returned, the monitor recovered to a healthy response.

### Lesson

A green monitor is not proof that monitoring works. Deliberately stopping a service is a much stronger validation test.

---

## 2. Disk-capacity branch needed verification

### Symptom

Disk usage could cross the workflow threshold and trigger cleanup.

### Investigation

The recovery path was limited to journal vacuuming and APT cache cleanup. Neither action guarantees that enough disk space will be reclaimed.

### Resolution

The workflow re-ran the disk-usage check after cleanup instead of assuming success from the command exit status alone.

### Lesson

Command success and incident resolution are different things. Remediation should be followed by a fresh measurement of the original problem.

---

## 3. Remote access conflict

### Symptom

Remote access to the CasaOS host stopped behaving as expected while another VPN configuration was active.

### Investigation

The problem was treated as a networking-path conflict rather than immediately as a CasaOS or application failure.

### Resolution

The conflicting VPN condition was removed and Tailscale-based access returned.

### Lesson

When remote access breaks, checking the routing/VPN layer can be more useful than troubleshooting the application first.

---

## 4. Plex library update problem

### Symptom

Media changes were not appearing as expected after a library update.

### Investigation

The issue was narrowed to the file/library state rather than assuming the Plex container itself was unhealthy.

### Resolution

Renaming/rescanning corrected the library behavior.

### Lesson

Application health and data/index health are separate troubleshooting domains. A service can be running correctly while its view of stored content is stale.

---

## 5. Local AI interface latency and connectivity

### Symptom

Local chat interfaces did not always behave like the underlying Ollama API.

### Investigation

Testing separated model/API reachability from UI behavior and request latency.

### Resolution

The work focused on confirming model connectivity first and then troubleshooting the interface layer independently.

### Lesson

Testing one layer at a time makes it easier to distinguish a model problem, an API problem, a container/network problem, and a front-end problem.

## General troubleshooting approach

Across the lab I tried to follow the same sequence:

```text
Observe the symptom
→ identify the layer involved
→ collect a direct measurement
→ change one thing
→ retest
→ verify the original symptom
```

That approach became more important as the lab added Docker services, monitoring logic, remote access, local AI, and NAS storage.
