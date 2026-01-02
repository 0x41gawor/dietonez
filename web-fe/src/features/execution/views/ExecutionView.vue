<template>
  <div class="execution-page">
    <div class="phone-shell moto-g84">
      <iframe
        class="execution-frame"
        src="/execution/"
        title="Dietonez Execution – Moto G84"
      />
    </div>
  </div>
</template>

<style scoped>
.execution-page {
  display: flex;
  padding-top: 2px; /* albo 8–12px */
  justify-content: center;
  align-items: flex-start;
  background: #f5f5f5;
  overflow: hidden;
}

/* ───────────────────────── */
/* Moto G84 shell */
/* ───────────────────────── */
.phone-shell.moto-g84 {
  width: 398.25px;     /* CSS viewport */
  height: 885px;    
  border-radius: 26px;
  background: #000;
  padding: 6px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.25);
}

.execution-frame {
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 18px;
  background: #000;
}
</style>